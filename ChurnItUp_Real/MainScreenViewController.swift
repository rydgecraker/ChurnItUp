//
//  MainScreenViewController.swift
//  ChurnItUp_Real
//
//  Created by Jennifer Diederich on 2/13/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//
//
//This view controller is the "main screen" (i.e. the screen with the churn on it that allows you to churn for butter.

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion
import CoreData
import Firebase

class MainScreenViewController: UIViewController, NSFetchedResultsControllerDelegate, GADRewardBasedVideoAdDelegate {
    

    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: butter, amount \(reward.amount).")
        earnButter(NSInteger(reward.amount))
    }
    var controller: NSFetchedResultsController<PlayerStats>!
  //Create a new instance of the CMMotionManager object to keep track of accelerometer data
    var motionManager = CMMotionManager()
    //MARK: removed all uses of numShakes replaces with player.churnsDone.
    //var numShakes: Int = 0
    public static var playerLoaded: PlayerStats?
  //Storing a SpriteKit scene for drawing the movable sprites to the screen (Such as the shaft of the curn or the amount of milk in the container)
    public static var mainScene: MainGameScene!
    
    public static var playerAlreadyLoaded: Bool = false
    
        
//Storing a SpriteKit scene for drawing the movable sprites to the screen (Such as the shaft of the curn or the amount of milk in the container)
    
    
    var rewardBasedVideo: GADRewardBasedVideoAd?
    
    let reward: Int = 7
    
    @IBOutlet weak var watchAdButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPlayer()
        loadPlayerFromCoreData()
        
            MainScreenViewController.playerAlreadyLoaded = true
        
        let skView = self.view as! SKView
        
        //Set up the spriteKit scene and start it's mathimatical calculations, and present the scene.
        MainScreenViewController.mainScene = MainGameScene(size: skView.bounds.size)
        MainScreenViewController.mainScene.start()
        MainScreenViewController.mainScene.scaleMode = .aspectFill
        
        skView.presentScene(MainScreenViewController.mainScene)
        
        //Update anything on the spriteKit scene that changes when varibales change (Such as player milk level)
        MainScreenViewController.mainScene.updateHUD()
        churnButter()
        
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        rewardBasedVideo?.load(GADRequest(),
                               withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
    }
    
    
    /*
     This function either:
     
     -Loads the player information from coreData into a Player object
     
     or
     
     -Creates a new Player object with default values set (If there is no saved player in coreData)
     */
    private func loadPlayerFromCoreData() {

        let playerExistsInCoreData = doesPlayerExistInCoreData()
        if(!playerExistsInCoreData) {
            Player.player = Player(milkVal: 10.0, butterVal: 7, luckLevelVal: 0.0, efficiencyVal: 0.0, churnsDoneVal: 0, maximumMilk: 10.0)
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
            MainScreenViewController.playerLoaded = playerStats
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
    
    //This function sets up the motionManager and creates the listener methods that are called when the accelerometer is shaken.
    func churnButter() {
        
        //Set the accelerometer to update every 0.2 seconds.
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let shakeData = data { //If the accelerometer has data
                if shakeData.acceleration.y > 0.5 { //If the accelerometer detects data in the Y direction and it's above our "minimum threshold of 0.5
                    
                    if(Player.player.milk > 0){ //If the player has enough milk to continue making butter.
                      Player.player.churnsDone += 1 //Increment the number of curns done by the player
                        
                      if (Player.player.churnsDone < Player.player.churnsNeeded) { //The player still requires more churns before they make a stick of butter
                          MainScreenViewController.mainScene.moveStaff() //Animates the movement of the staff.

                      } else { //The player has enough churns to make a stick of butter
                        //Subtrack a milk from the player's total milk and add a butter to their total butter supply. Reset the number of churns to zero and then update the UI so that the changes appear on screen.
                          Player.player.milk -= 1
                          Player.player.churnsDone = 0
                          Player.player.butter += 1
                          MainScreenViewController.mainScene.moveStaff()
                          MainScreenViewController.mainScene.updateHUD()
                      }
                    } else { //Player doesn't have enough milk to begin churning butter
                        // Display "out of milk, find more" message
                        let alert = UIAlertController(title: "OUT OF MILK!" , message: "Go find some cows to continue!", preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
                        
                        alert.addAction(alertAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    
    @IBAction func showAd(_ sender: Any) {
        if rewardBasedVideo?.isReady == true {
        rewardBasedVideo?.present(fromRootViewController: self)
            
        }
    }
    
    func earnButter(_ reward: NSInteger) {
        Player.player.butter += reward
        MainScreenViewController.mainScene.updateHUD()
        print("im here")
    }
    
}
