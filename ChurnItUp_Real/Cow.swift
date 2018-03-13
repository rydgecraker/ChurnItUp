//
//  Cow.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/27/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//
//This class controls all variables dealing with the cow object.

import UIKit

class Cow {

    var milk: Double = 0
    var cowType: String = ""
    
    //Creates a new cow with milk and a type
    init(milkAmt: Double, typeOfCow: String){
        cowType = typeOfCow
        milk = milkAmt
        
    }
    
    //Generates a new cow based on the player's luck value and a percentage roll.
    static func generateCow(luckValueMultiplier: Double) -> Cow {
        let commonMax = 60 + (luckValueMultiplier * 40) //Base chance for a common cow is 60%
        let unCommonMax = commonMax + 25 + (luckValueMultiplier * 30) //Base chance for an uncommon cow is 25%
        let rareMax = unCommonMax + 10 + (luckValueMultiplier * 20) //Base chance for a rare cow is 10%
        //base chance for a legendary cow is 5%
        
        let randRoll = (Double(arc4random_uniform(100)) + 1.0) * (1 + luckValueMultiplier) //Get a random number between 1 and 100 inclusive
        
        var cow: Cow!
        
        //create a cow based on the roll.
        if(randRoll > rareMax){
            cow = Cow.init(milkAmt: 100, typeOfCow: "L")
        } else if(randRoll > unCommonMax){
            cow = Cow.init(milkAmt: 25, typeOfCow: "R")
        } else if(randRoll > commonMax){
            cow = Cow.init(milkAmt: 10, typeOfCow: "U")
        } else {
            cow = Cow.init(milkAmt: 1, typeOfCow: "C")
        }
        
        //Check to see if the sasquatch appears.
        cow.cowType = cowSasquatchRoll(cow: cow)
        
        //return the cow.
        return cow
    }
    
    static func cowSasquatchRoll(cow: Cow) -> String {
        //Roll to see if sasquatch appears.
        return cow.cowType
    }
    
    //Returns an image of the cow (or sasquatch) based on its type.
    func getCowImage() -> UIImage {
        switch cowType {
        case "L":
            let lgd = arc4random_uniform(2)
            if lgd == 0 {
                return #imageLiteral(resourceName: "goldCow")
            } else {
                return #imageLiteral(resourceName: "almondCow")
            }
        case "R":
            return #imageLiteral(resourceName: "strawberryCow")
        case "U" :
            return #imageLiteral(resourceName: "chocolateCow")
        case "C":
            return #imageLiteral(resourceName: "basicCow")
        case "sasquatch":
            return #imageLiteral(resourceName: "basicCow")
        default:
            return #imageLiteral(resourceName: "basicCow")
        }
    }
    
}
