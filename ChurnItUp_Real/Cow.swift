//
//  Cow.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/27/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class Cow {

    var milk: Int = 0
    var cowType: String = ""
    
    init(milkAmt: Int, typeOfCow: String){
        cowType = typeOfCow
        milk = milkAmt
        
    }
    
    static func generateCow(luckValueMultiplier: Double) -> Cow {
        let commonMax = 60 + (luckValueMultiplier * 40)
        let unCommonMax = commonMax + 25 + (luckValueMultiplier * 30)
        let rareMax = unCommonMax + 10 + (luckValueMultiplier * 20)
        
        let randRoll = (Double(arc4random_uniform(100)) + 1.0) * (1 + luckValueMultiplier)
        
        if(randRoll > rareMax){
            return Cow.init(milkAmt: 1, typeOfCow: "L")
        } else if(randRoll > unCommonMax){
            return Cow.init(milkAmt: 10, typeOfCow: "R")
        } else if(randRoll > commonMax){
            return Cow.init(milkAmt: 25, typeOfCow: "U")
        } else {
            return Cow.init(milkAmt: 100, typeOfCow: "C")
        }
        
        
    }
    
}
