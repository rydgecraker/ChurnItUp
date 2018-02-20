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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        let scene = MainGameScene(size: skView.bounds.size)
        
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let shakeData = data {
                print("Phone Still")
                
                if shakeData.acceleration.x > 2 {
                    print("Phone Shaken")
                }
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
