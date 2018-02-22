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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    
    func churnButter() {

        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let shakeData = data {
               // print(shakeData.acceleration.y)
                if shakeData.acceleration.y > -0.5 {
                    
                    // MainGameScene.shake()
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
        
        print("game status")
        
        let fileName = Bundle.main.url(forResource: "gameStats", withExtension: "txt")!
            
            print(fileName)
            
            do {
                
                let fileContent = try String(contentsOf: fileName, encoding: String.Encoding.utf8)
                let gameStats = fileContent.components(separatedBy: "\n")
                print(gameStats)
                
                if(fileContent == "") {
                    
                }
                
            } catch {
                print("Unable to open file")
            }

    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
