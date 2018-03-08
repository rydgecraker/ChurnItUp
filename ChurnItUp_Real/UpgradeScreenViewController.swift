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
    var mainScene: MainGameScene!
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
        milkCanLevel.text = String(Int(player.maxMilk))
        butterLevel.text = String(player.butter)
        self.navigationItem.setHidesBackButton(true, animated: false)
        //Function for button enabling and image change

    }
  
  
    func getStats(){
        //creates local Levels from player object's double values
        luck = Int(player.luckLevel * 10)
        efficiency = Int(player.efficiencyLevel * 10)
        milkCan = Int((player.maxMilk - 10) / 10)
    }

    func checkUpgrades(){
        getStats()
        //Check luck
        if luck == player.maxLuckLevel {
            butterForLuck.text = "N/A"
            disableButton(luckButton)
        } else {
            butterForLuck.text = String(butterNeeded[luck])
            if player.butter >= butterNeeded[luck] {
                enableButton(luckButton)
            }else {
                disableButton(luckButton)
            }
        }
        
        //Check efficiency
        if efficiency == player.maxEfficiencyLevel {
            butterForEfficiency.text = "N/A"
            disableButton(efficiencyButton)
        } else {
            butterForEfficiency.text = String(butterNeeded[efficiency])
            if player.butter >= butterNeeded[efficiency] {
                enableButton(efficiencyButton)
            }else {
                disableButton(efficiencyButton)
            }
        }
        
        //Check milk
        if milkCan == player.maxMilkLevel {
            butterForMilkCan.text = "N/A"
            disableButton(milkCanButton)
        } else {
            butterForMilkCan.text = String(butterNeeded[milkCan])
            if player.butter >= butterNeeded[milkCan] {
                enableButton(milkCanButton)
            }else {
                disableButton(milkCanButton)
            }
        }
    }
    
    @IBAction func increaseLuck(_ sender: Any) {
        player.butter -= butterNeeded[luck]
        player.upgradeLuck()
        checkUpgrades()
        butterLevel.text = String(player.butter)
        luckLevel.text = String(luck)
        mainScene.updateHUD()
    }
    
    @IBAction func increaseEfficiency(_ sender: Any) {
        player.butter -= butterNeeded[efficiency]
        player.upgradeEfficiencyLevel()
        checkUpgrades()
        butterLevel.text = String(player.butter)
        efficiencyLevel.text = String(efficiency)
        mainScene.updateHUD()
    }
    
    @IBAction func increaseMilkCanSize(_ sender: Any) {
        player.butter -= butterNeeded[milkCan]
        player.upgradeMilkCapacity()
        checkUpgrades()
        butterLevel.text = String(player.butter)
        milkCanLevel.text = String(Int(player.maxMilk))
        mainScene.updateHUD()
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
//Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MainScreenViewController
        {
            let msvc = segue.destination as? MainScreenViewController
            msvc?.mainScene = self.mainScene
            msvc?.player = self.player
        }
        self.navigationController?.popViewController(animated: true)
    }
}
