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
    var milk: Double = 0
    var butter: Int = 0
    
    //Upgrades
    var luckLevel: Double = 0//.1 per upgrade //Max 0.5
    var efficiencyLevel: Double = 0 //.1 per upgrade //Max 1.0
    var maxMilk: Double = 0.0 //+10 per upgrade //Max 100
    
    //Progress
    var churnsDone: Int = 0
    var churnsNeeded: Int = 0
    
    //Constants
    let initialChurns: Int = 3
    let maxLuckLevel = 5
    let maxEfficiencyLevel = 10
    let maxMilkLevel = 9
    
    init(milkVal: Double, butterVal: Int, luckLevelVal: Double, efficiencyVal: Double, churnsDoneVal: Int, maximumMilk: Double){
        milk = milkVal
        butter = butterVal
        luckLevel = luckLevelVal
        efficiencyLevel = efficiencyVal
        churnsDone = churnsDoneVal
        maxMilk = maximumMilk
        //MARK: This (below) does not need to be saved to the userdefaults since it is being calculated from a constant
        churnsNeeded = initialChurns - Int(Double(initialChurns) * efficiencyLevel)
    }
    
    func upgradeLuck(){
        luckLevel += 0.1
        if(luckLevel > 0.5){
            luckLevel = 0.5
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
        churnsNeeded = initialChurns - Int(Double(initialChurns) * efficiencyLevel)
        // if increased efficiency creates a butter reset churns, add butter, subtract milk
        if churnsDone >= churnsNeeded {
            butter += 1
            churnsDone = 0
            milk -= 1
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


extension UserDefaults {
    
    func setAllValues(player: Player) {
        setMilkVal(player.milk)
        setButterVal(player.butter)
        setLuckLevelVal(player.luckLevel)
        setEfficiencyVal(player.efficiencyLevel)
        setChurnsDoneVal(player.churnsDone)
        setMaximunMilkVal(player.maxMilk)
    }
    
    func loadAllValues() -> Player {
        return Player.init(milkVal: getMilkVal(), butterVal: getButterVal(), luckLevelVal: getLuckLevelVal(), efficiencyVal: getEfficiencyVal(), churnsDoneVal: getChurnsDoneVal(), maximumMilk: getMaximunMilkVal())
    }
    
    // Set Value
    func setMilkVal(_ milk: Double) {
        set(milk, forKey: UserDefaultsKeys.milk.rawValue)
    }
    
    // Get Value
    func getMilkVal() -> Double{
        return double(forKey: UserDefaultsKeys.milk.rawValue)
    }
   
    func setButterVal(_ butter: Int) {
        set(butter, forKey: UserDefaultsKeys.butter.rawValue)
    }
    
    // Get Value
    func getButterVal() -> Int{
        return integer(forKey: UserDefaultsKeys.butter.rawValue)
    }
    
    func setLuckLevelVal(_ luckLevel: Double) {
        set(luckLevel, forKey: UserDefaultsKeys.luckLevel.rawValue)
    }
    
    // Get Value
    func getLuckLevelVal() -> Double{
        return double(forKey: UserDefaultsKeys.luckLevel.rawValue)
    }
    
    // Get Value
    
    func setEfficiencyVal(_ efficiency: Double) {
        set(efficiency, forKey: UserDefaultsKeys.efficiency.rawValue)
    }
    
    // Get Value
    func getEfficiencyVal() -> Double{
        return double(forKey: UserDefaultsKeys.efficiency.rawValue)
    }
    
    func setChurnsDoneVal(_ churnsDone: Int) {
        set(churnsDone, forKey: UserDefaultsKeys.churnsDone.rawValue)
    }
    
    // Get Value
    func getChurnsDoneVal() -> Int{
        return integer(forKey: UserDefaultsKeys.churnsDone.rawValue)
    }
    
    func setMaximunMilkVal(_ maximumMilk: Double) {
        set(maximumMilk, forKey: UserDefaultsKeys.maximumMilk.rawValue)
    }
    
    // Get Value
    func getMaximunMilkVal() -> Double{
        return double(forKey: UserDefaultsKeys.maximumMilk.rawValue)
    }
    
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}


enum UserDefaultsKeys : String {
    case milk
    case butter
    case luckLevel
    case efficiency
    case churnsDone
    case maximumMilk
    
}
