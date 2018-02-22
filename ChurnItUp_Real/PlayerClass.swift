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
    var luckLevel: Int = 0//.1 per upgrade
    var efficiencyLevel: Int = 0 //.1 per upgrade
    
    //Progress
    var churnsDone: Int = 0
    
    init(_ milkVal: Int, _ butterVal:Int, _ luckLevelVal:Int, _ efficiencyVal:Int, _ churnsDoneVal:Int){
        milk = milkVal
        butter = butterVal
        luckLevel = luckLevelVal
        efficiencyLevel = efficiencyVal
        churnsDone = churnsDoneVal
        
    }

}
