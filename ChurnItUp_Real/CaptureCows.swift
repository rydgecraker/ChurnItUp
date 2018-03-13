//
//  CaptureCows.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/27/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//
//
//This screen shows a random cow (or sasquatch) and allows you to capture it.

import UIKit

class CaptureCows: UIViewController {

    //Creates a cow
    var cow: Cow!
    
    
    @IBOutlet weak var cowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Generate a cow based on the player's luck value
        cow = Cow.generateCow(luckValueMultiplier: Player.player.luckLevel)
        //Show the cow's appearence to the player.
        cowButton.setBackgroundImage(cow.getCowImage(), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //When the cow button is pressed, add milk to the player's supply (or deal with the sasquatch)
        if(cow.cowType != "sasquatch"){
            Player.player.addMilk(cow.milk)
        } else {
            Player.player.addMilk(-Player.player.milk)
            Player.player.butter = 0
        }
    }

}
