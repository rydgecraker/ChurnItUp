//
//  CaptureCows.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/27/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class CaptureCows: UIViewController {

    var player: Player!
    var cow: Cow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cow = Cow.generateCow(luckValueMultiplier: player.luckLevel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cowButtonPressed(_ sender: Any) {
        player.addMilk(cow.milk)
    }

}
