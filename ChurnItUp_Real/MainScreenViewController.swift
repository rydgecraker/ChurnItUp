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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let skView = self.view as! SKView
        
        let mainScene = MainGameScene(size: skView.bounds.size)
        
        mainScene.scaleMode = .aspectFill
        
        skView.presentScene(mainScene)

        // Check status of game
        gameStatus()
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
    }
    
    func churnButter() {

        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let shakeData = data {
                if shakeData.acceleration.y > -0.5 {
                    
                    self.numShakes += 1
                    // Make the butter churn, churn once.
                    
                    if (self.numShakes < 50) {
                        
                    }
                    
                } else {
                    //Ignore this.
                }
            }
        }
    }
    

    func gameStatus() {
        
        let fileName = Bundle.main.url(forResource: "gameStats", withExtension: "txt")!
            
            do {
                
                let fileContent = try String(contentsOf: fileName, encoding: String.Encoding.utf8)
                let gameStats = fileContent.components(separatedBy: "\n")
                
                if(fileContent == "") {
                    // Create file
                }
                
                //load the file
                
            } catch {
                print("ERROR - Unable to open file")
            }

    }

}
