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

class MainScreenViewController: UIViewController {
    
    //Create a new instance of the CMMotionManager object to keep track of accelerometer data
    var motionManager = CMMotionManager()
    //Storing a SpriteKit scene for drawing the movable sprites to the screen (Such as the shaft of the curn or the amount of milk in the container)
    var mainScene: MainGameScene!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPlayerFromCoreData()
        
        let skView = self.view as! SKView
        
        //Set up the spriteKit scene and start it's mathimatical calculations, and present the scene.
        mainScene = MainGameScene(size: skView.bounds.size)
        mainScene.start()
        mainScene.scaleMode = .aspectFill
        
        skView.presentScene(mainScene)
        
        //Update anything on the spriteKit scene that changes when varibales change (Such as player milk level)
        mainScene.updateHUD()
        churnButter()

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
            Player.player = Player(milkVal: 10.0, butterVal: 0, luckLevelVal: 0.0, efficiencyVal: 0.0, churnsDoneVal: 0, maximumMilk: 10.0)
            savePlayerToCoreData()
        } else {
            //Load it from core data
            loadPlayer()
        }
    }
    
    func doesPlayerExistInCoreData() -> Bool {
        return false
    }
    
    func savePlayerToCoreData(){
        
    }
    
    func loadPlayer(){
        
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
                          self.mainScene.moveStaff() //Animates the movement of the staff.

                      } else { //The player has enough churns to make a stick of butter
                        //Subtrack a milk from the player's total milk and add a butter to their total butter supply. Reset the number of churns to zero and then update the UI so that the changes appear on screen.
                          Player.player.milk -= 1
                          Player.player.churnsDone = 0
                          Player.player.butter += 1
                          self.mainScene.moveStaff()
                          self.mainScene.updateHUD()
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

}
