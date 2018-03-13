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

class MainScreenViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    //MARK: removed all uses of numShakes replaces with player.churnsDone.
    //var numShakes: Int = 0
    var mainScene: MainGameScene!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
