//
//  UpgradeScreenViewController.swift
//  ChurnItUp_Real
//
//  Created by Jennifer Diederich on 2/15/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class UpgradeScreenViewController: UIViewController {

    var player: Player!
    
    let maxLuckLevel = 5
    let maxEfficiencyLevel = 5
    let maxMilkCan = 10
    var luck = 0
    var efficiency = 0
    var milkCan = 0
    var butter = 0
    
    @IBOutlet weak var luckLevel: UILabel!
    @IBOutlet weak var efficiencyLevel: UILabel!
    @IBOutlet weak var milkCanLevel: UILabel!
    @IBOutlet weak var butterLevel: UILabel!
    
    @IBOutlet weak var butterForLuck: UILabel!
    @IBOutlet weak var butterForEfficiency: UILabel!
    @IBOutlet weak var butterForMilkCan: UILabel!
    
    @IBOutlet weak var luckButton: UIButton!
    @IBOutlet weak var efficiencyButton: UIButton!
    @IBOutlet weak var milkCanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        luck = Int(player.luckLevel * 10)
        efficiency = Int(player.efficiencyLevel * 10)
        milkCan = Int((player.maxMilk - 10) / 10)
        butter = Int(player.butter)
        
        luckLevel.text = String(luck)
        efficiencyLevel.text = String(efficiency)
        milkCanLevel.text = String(milkCan)
        butterLevel.text = String(butter)
    }

    @IBAction func increaseEfficiency(_ sender: Any) {
        //TODO: If current churns put you over
    }
    
    @IBAction func increaseLuck(_ sender: Any) {
    
    
    
    }
    
    @IBAction func increaseMilkCanSize(_ sender: Any) {
    
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MainScreenViewController
        {
            let cc = segue.destination as? MainScreenViewController
            cc?.player = self.player
        }
        self.navigationController?.popViewController(animated: true)
    }
}
