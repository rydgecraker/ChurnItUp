//
//  PlayerClass.swift
//  ChurnItUp_Real
//
//  Created by Jon Vollmer on 2/20/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

class Player {
        //Inventory
    var milk: Int = 10
    var butter: Int = 0
    
    //Upgrades
    var luckLevel: Double = 0//.1 per upgrade //Max 0.5
    var efficiencyLevel: Double = 0 //.1 per upgrade //Max 1.0
    var maxMilk: Int = 10 //+10 per upgrade //Max 100
    
    //Progress
    var churnsDone: Int = 0
    
    init(milkVal: Int, butterVal:Int, luckLevelVal:Double, efficiencyVal:Double, churnsDoneVal:Int, maximumMilk: Int){
        milk = milkVal
        butter = butterVal
        luckLevel = luckLevelVal
        efficiencyLevel = efficiencyVal
        churnsDone = churnsDoneVal
        maxMilk = maximumMilk
    }
    
    func upgradeLuck(){
        luckLevel += 0.1
        if(luckLevel > 0.5){
            luckLevel = 0.5;
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
    
    func addMilk(_ milk: Int){
        self.milk += milk
        if(self.milk > maxMilk){
            self.milk = maxMilk
        }
    }

}
