//
//  ViewController.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/8/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let SegueMainScreenViewController = "MainScreenViewController"

    var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Use the passed in values here
        player = Player.init(milkVal: 10, butterVal: 0, luckLevelVal: 0.0, efficiencyVal: 0.0, churnsDoneVal: 0, maximumMilk: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MainScreenViewController
        {
            let msvc = segue.destination as? MainScreenViewController
            msvc?.player = self.player
        }
    }
    
  @IBAction func StartButtonPressed(_ sender: Any) {
    
    }


}

