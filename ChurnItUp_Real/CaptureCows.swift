//
//  CaptureCows.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/27/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class CaptureCows: UIViewController {

    var cow: Cow!
    
    @IBOutlet weak var cowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        cow = Cow.generateCow(luckValueMultiplier: Player.player.luckLevel)
        cowButton.setBackgroundImage(cow.getCowImage(), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
