//
//  UpgradeScreenViewController.swift
//  ChurnItUp_Real
//
//  Created by Jennifer Diederich on 2/15/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class UpgradeScreenViewController: UIViewController {

    var luck = 0
    var efficiency = 0
    var milkCan = 0
    let butterNeeded = [7, 15, 30, 60, 125, 250, 375, 500, 750, 1000, 0]
    
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
        checkUpgrades()
        luckLevel.text = String(luck)
        efficiencyLevel.text = String(efficiency)
        milkCanLevel.text = String(Int(Player.player.maxMilk))
        butterLevel.text = String(Player.player.butter)
        //Function for button enabling and image change

    }
  
  
    func getStats(){
        //creates local Levels from player object's double values
        luck = Int(Player.player.luckLevel * 10)
        efficiency = Int(Player.player.efficiencyLevel * 10)
        milkCan = Int((Player.player.maxMilk - 10) / 10)
    }

    func checkUpgrades(){
        print(Player.player.butter)
        getStats()
        //Check luck
        if luck == Player.player.maxLuckLevel {
            butterForLuck.text = "N/A"
            disableButton(luckButton)
        } else {
            butterForLuck.text = String(butterNeeded[luck])
            if Player.player.butter >= butterNeeded[luck] {
                enableButton(luckButton)
            }else {
                disableButton(luckButton)
            }
        }
        
        //Check efficiency
        if efficiency == Player.player.maxEfficiencyLevel {
            butterForEfficiency.text = "N/A"
            disableButton(efficiencyButton)
        } else {
            butterForEfficiency.text = String(butterNeeded[efficiency])
            if Player.player.butter >= butterNeeded[efficiency] {
                enableButton(efficiencyButton)
            }else {
                disableButton(efficiencyButton)
            }
        }
        
        //Check milk
        if milkCan == Player.player.maxMilkLevel {
            butterForMilkCan.text = "N/A"
            disableButton(milkCanButton)
        } else {
            butterForMilkCan.text = String(butterNeeded[milkCan])
            if Player.player.butter >= butterNeeded[milkCan] {
                enableButton(milkCanButton)
            }else {
                disableButton(milkCanButton)
            }
        }
    }
    
    @IBAction func increaseLuck(_ sender: Any) {
        Player.player.butter -= butterNeeded[luck]
        Player.player.upgradeLuck()
        checkUpgrades()
        butterLevel.text = String(Player.player.butter)
        luckLevel.text = String(luck)
    }
    
    @IBAction func increaseEfficiency(_ sender: Any) {
        Player.player.butter -= butterNeeded[efficiency]
        Player.player.upgradeEfficiencyLevel()
        checkUpgrades()
        butterLevel.text = String(Player.player.butter)
        efficiencyLevel.text = String(efficiency)
    }
    
    @IBAction func increaseMilkCanSize(_ sender: Any) {
        Player.player.butter -= butterNeeded[milkCan]
        Player.player.upgradeMilkCapacity()
        checkUpgrades()
        butterLevel.text = String(Player.player.butter)
        milkCanLevel.text = String(Int(Player.player.maxMilk))
    }
    
//helper functions
    func enableButton(_ button: UIButton){
        button.isEnabled = true
        button.setImage(#imageLiteral(resourceName: "upgradePlusActive"), for: .normal)
    }
    
    func disableButton(_ button: UIButton){
        button.isEnabled = false
        button.setImage(#imageLiteral(resourceName: "upgradePlusInactive"), for: .normal)
    }
    
    func updateLabels(label: UILabel,value:Int){

    }
}
