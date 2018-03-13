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
    public static var playerLoaded: PlayerStats?
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
        print("First")
        print(controller.fetchedObjects?.first! ?? "")
        print("Last")
        print(controller.fetchedObjects?.last! ?? "")
    }
    
    private func loadPlayerFromCoreData() {
        let playerExistsInCoreData = doesPlayerExistInCoreData()
        if(!playerExistsInCoreData) {
            Player.player = Player(milkVal: 10.0, butterVal: 8000, luckLevelVal: 0.0, efficiencyVal: 0.0, churnsDoneVal: 0, maximumMilk: 10.0)
            //need to check for new records
            savePlayerToCoreData()
        } else {
            //Load it from core data
            loadPlayer()
        }
    }
    
    func doesPlayerExistInCoreData() -> Bool {
        if let stats = controller.fetchedObjects?.first, stats.player_name == "Player1" {
            MainScreenViewController.playerLoaded = stats
            print(stats)
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
        
        if MainScreenViewController.playerLoaded == nil {
            playerStats = NSManagedObject(entity: entity!, insertInto: managedContext) as! PlayerStats
            
        }else {
            playerStats = MainScreenViewController.playerLoaded
        }

        playerStats.player_name = "Player1"
        playerStats.date_last_played = Date()
        playerStats.butter = Int32(Player.player.butter)
        playerStats.churns_done = Int16(Player.player.churnsDone)
        playerStats.efficiency_level = Player.player.efficiencyLevel
        playerStats.luck_level = Player.player.luckLevel
        playerStats.milk = Player.player.milk
        playerStats.max_milk = Int16(Player.player.maxMilk)
        /*
        playerStats.setValue("Player1", forKey: "player_name")
        playerStats.setValue(Player.player.butter, forKey: "butter")
        playerStats.setValue(Player.player.churnsDone, forKey: "churns_done")
        playerStats.setValue(Player.player.efficiencyLevel, forKey: "efficiency_level")
        playerStats.setValue(Player.player.luckLevel, forKey: "luck_level")
        playerStats.setValue(Player.player.maxMilk, forKey: "max_milk")
        playerStats.setValue(Player.player.milk, forKey: "milk")
        playerStats.setValue(Date(), forKey: "date_last_played")
        */
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
        let sort: NSSortDescriptor = NSSortDescriptor(key: "player_name", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        do {
            try self.controller.performFetch()
        } catch let error as NSError{
            print("Could not fetch: \(error), \(error.userInfo)")
        }
    }

    func loadPlayer(){
        if let stats = controller.fetchedObjects?.first{
            Player.player = Player(milkVal: stats.milk, butterVal: Int(stats.butter), luckLevelVal: Double(stats.luck_level), efficiencyVal: Double(stats.efficiency_level), churnsDoneVal: Int(stats.churns_done), maximumMilk: Double(stats.max_milk))
        }
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
