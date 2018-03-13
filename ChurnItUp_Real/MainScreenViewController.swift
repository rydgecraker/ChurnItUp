//
//  MainScreenViewController.swift
//  ChurnItUp_Real
//
//  Created by Jennifer Diederich on 2/13/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion
import CoreData

class MainScreenViewController: UIViewController, NSFetchedResultsControllerDelegate{
    var controller: NSFetchedResultsController<PlayerStats>!
    var motionManager = CMMotionManager()
    //MARK: removed all uses of numShakes replaces with player.churnsDone.
    //var numShakes: Int = 0
    var playerLoaded: PlayerStats?
    var mainScene: MainGameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPlayer()
        loadPlayerFromCoreData()
        
        let skView = self.view as! SKView
        
        mainScene = MainGameScene(size: skView.bounds.size)
        mainScene.start()
        mainScene.scaleMode = .aspectFill
        
        skView.presentScene(mainScene)
        
        mainScene.updateHUD()
        
        churnButter()

    }
    
    private func loadPlayerFromCoreData() {
        let playerExistsInCoreData = doesPlayerExistInCoreData()
        if(!playerExistsInCoreData) {
            Player.player = Player(milkVal: 10.0, butterVal: 0, luckLevelVal: 0.0, efficiencyVal: 0.0, churnsDoneVal: 0, maximumMilk: 10.0)
            //need to check for new records
            //savePlayerToCoreData()
        } else {
            //Load it from core data
            playerLoaded 
            loadPlayer()
        }
    }
    
    func doesPlayerExistInCoreData() -> Bool {
        let stats = controller.object(at: 0)
        if stats.player_name == "Player1" {
            playerLoaded = stats
            return true
        } else {
            return false
        }
    }
    
    func savePlayerToCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PlayerStats", in: managedContext)
        /*let playerData = NSManagedObject(entity: entity!, insertInto: managedContext)
        playerData.setValue("Player1", forKey: "player_name")
        playerData.setValue(Player.player.butter, forKey: "butter")
        playerData.setValue(Player.player.churnsDone, forKey: "churns_done")
        playerData.setValue(Player.player.efficiencyLevel, forKey: "efficiency_level")
        playerData.setValue(Player.player.luckLevel, forKey: "luck_level")
        playerData.setValue(Player.player.maxMilk, forKey: "max_milk")
        playerData.setValue(Player.player.milk, forKey: "milk")
        playerData.setValue(Date(), forKey: "date_last_played")
*/
        var playerStats: PlayerStats!
        
        if playerLoaded == nil {
            playerStats = PlayerStats(context: managedContext)
        }else {
            playerStats = playerLoaded
        }
        playerStats.player_name = "Player1"
        playerStats.date_last_played = Date()
        if let butter = Player.player.butter {
            playerStats.butter = butter
        }
        
        if let churnsDone = Player.player.churnsDone {
            playerStats.churns_done = churnsDone
        }
        
        if let efficiencyLevel = Player.player.efficiencyLevel {
            playerStats.efficiency_level = efficiencyLevel
        }
        
        if let luckLevel = Player.player.luckLevel {
            playerStats.luck_level = luckLevel
        }
        if let milk = Player.player.milk {
            playerStats.milk = milk
        }
        if let maxMilk = Player.player.maxMilk {
            playerStats.max_milk = maxMilk
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error), \(error.userInfo)")
        }
        
    }
    func fetchPlayer() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PlayerStats> = PlayerStats.fetchRequest()
        let playerFilter = NSPredicate(format: "player_name == %@", "Player1")
        fetchRequest.predicate = playerFilter
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        do {
            try controller.performFetch()
        } catch let error as NSError{
            print("Could not fetch: \(error), \(error.userInfo)")
        }
    }

    func loadPlayer(){
        let stats = controller.object(at: 0)
        Player.player.butter = stats.butter
        Player.player.churnsDone = stats.churns_done
        Player.player.efficiencyLevel = stats.efficiency_level
        Player.player.luckLevel = stats.luck_level
        Player.player.maxMilk = stats.max_milk
        Player.player.milk = stats.milk
    }
    
    func churnButter() {

        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let shakeData = data {
                if shakeData.acceleration.y > 0.5 {
                    if(Player.player.milk > 0){
                      // MainGameScene.shake()
                      //MARK: Got rid of numShakes since we needed the churnsDone for all other calcs. -JV
                      Player.player.churnsDone += 1
                      //MARK: changed this to use player churnsDone and churnsNeeded, instead of hardcoded, max value and numshakes
                      // Make the butter churn, churn once
                      if (Player.player.churnsDone < Player.player.churnsNeeded) {
                          // print("Current Number of Shakes \(self.numShakes)")
                          print("ChurnsDone \(Player.player.churnsDone)")
                          self.mainScene.moveStaff()

                      } else {
                          //MARK: I added subtract milk (previous milk  -JV
                          Player.player.milk -= 1
                          Player.player.churnsDone = 0
                          Player.player.butter += 1
                          self.mainScene.moveStaff()
                          self.mainScene.updateHUD()
                          print("Shakes over \(Player.player.churnsNeeded): Current Churns Done \(Player.player.churnsDone)")
                          print("Shakes over \(Player.player.churnsNeeded): Current Number of Butter \(Player.player.butter)")
                      }
                    } else {
                        // You don't have milk. you cant make butter!
                        let alert = UIAlertController(title: "OUT OF MILK!" , message: "Go find some cows to continue!", preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
                        
                        alert.addAction(alertAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

}
