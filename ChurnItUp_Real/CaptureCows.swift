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
    
    @IBOutlet weak var cowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        cow = Cow.generateCow(luckValueMultiplier: player.luckLevel)
        cowButton.setBackgroundImage(cow.getCowImage(), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        player.addMilk(cow.milk)
        if segue.destination is MainScreenViewController
        {
            let msvc = segue.destination as? MainScreenViewController
            msvc?.player = self.player
        }
    }

}
