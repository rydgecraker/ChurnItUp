//
//  PlayerClass.swift
//  ChurnItUp_Real
//
//  Created by Jon Vollmer on 2/20/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class Player {
        //Inventory
    var milk: Double = 10
    var butter: Int = 0
    
    //Upgrades
    var luckLevel: Double = 0//.1 per upgrade //Max 0.5
    var luckUpgrade: Int = 0
    var efficiencyLevel: Double = 0 //.1 per upgrade //Max 1.0
    var maxMilk: Double = 10.0 //+10 per upgrade //Max 100
    
    //Progress
    var churnsDone: Int = 0
    
    init(milkVal: Double, butterVal:Int, luckLevelVal:Double, efficiencyVal:Double, churnsDoneVal:Int, maximumMilk: Double){
        milk = milkVal
        butter = butterVal
        luckLevel = luckLevelVal
        efficiencyLevel = efficiencyVal
        churnsDone = churnsDoneVal
        maxMilk = maximumMilk
    }
    
    func upgradeLuck(){
        luckLevel += 0.1
        luckUpgrade += 1
        if(luckLevel > 0.5){
            luckLevel = 0.5;
            luckUpgrade = 5
        }
    }
    
    func upgradeMilkCapacity(){
        maxMilk += 10
        if(maxMilk > 100){
            maxMilk = 100
        }
    }
    
    func upgradeEfficiencyLevel(){
        efficiencyLevel += 0.1
        if(efficiencyLevel > 1.0){
            efficiencyLevel = 1.0
        }
    }
    
    func addMilk(_ milk: Double){
        self.milk += milk
        if(self.milk > maxMilk){
            self.milk = maxMilk
        }
    }
    
    func getMilkPercent() -> CGFloat {
        return CGFloat(milk / maxMilk)
    }

}
