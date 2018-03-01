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
    var numShakes: Int = 0
    var player: Player!
    
    let player2 = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let skView = self.view as! SKView
        
        let mainScene = MainGameScene(size: skView.bounds.size)
        mainScene.start(player: self.player)
        mainScene.scaleMode = .aspectFill
        
        skView.presentScene(mainScene)

        print("MilkValue getMilkVal() : \(UserDefaults.standard.getMilkVal())")
        print("MilkValue getMaxMilkVal() : \(UserDefaults.standard.getMaximunMilkVal())")
        
        // Check status of game
        
        churnButter()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GetLocationViewController
        {
            let glvc = segue.destination as? GetLocationViewController
            glvc?.player = self.player
        }
        
        if segue.destination is UpgradeScreenViewController
        {
            let usvc = segue.destination as? UpgradeScreenViewController
            usvc?.player = self.player
        }
        
    }
    
    func churnButter() {

        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let shakeData = data {
                if shakeData.acceleration.y > 0.5 {
                    print("here")
                    // MainGameScene.shake()
                    self.numShakes += 1
                    // Make the butter churn, churn once.
                    
                    if (self.numShakes < 25) {
                        
                        self.player.churnsDone = self.numShakes
                        // print("Current Number of Shakes \(self.numShakes)")
                        print("ChurnsDone \(self.player.churnsDone)")
                        
                    } else {
                        
                        self.numShakes = 0
                        self.player.butter += 1
                        
                        print("Shakes over 25: Current Churns Done \(self.player.churnsDone)")
                        print("Shakes over 25: Current Number of Butter \(self.player.butter)")
                        
                        
                    }
                    
                } else {
                    //Ignore this.
                }
            }
        }
    }
    
}
