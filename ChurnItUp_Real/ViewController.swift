//
//  ViewController.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/8/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let SegueMainScreenViewController = "MainScreenViewController"

    var player: Player!
    
    var mainScreen = MainScreenViewController.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Use the passed in values here
        player = Player.init(milkVal: 10.0, butterVal: 0, luckLevelVal: 0.0, efficiencyVal: 0.0, churnsDoneVal: 0, maximumMilk: 10.0)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MainScreenViewController
        {
            let msvc = segue.destination as? MainScreenViewController
            msvc?.player = self.player
            //print("Here? \(player.milk)")
        }
    }
    
    
@IBAction func StartButtonPressed(_ sender: Any) {
//    checkForGameStatsFile()
    
    if(UserDefaults.exists(key: UserDefaultsKeys.milk.rawValue)) {
        
        //print("MilkValue getMilkVal() : \(UserDefaults.standard.getMilkVal())")
        player = UserDefaults.standard.loadAllValues()
        //print("Via get \(player.milk)")
        
       
    } else {
        
        UserDefaults.standard.setAllValues(player: player)
        
    }
}

    
    
//    func checkForGameStatsFile() {
//
//        // Check if plist exists
//
//        let fileManager = FileManager.default
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
//        let documentDirectory = path[0] as! String
//        let filePath = documentDirectory.appending("gameStats.plist")
//
//        if !fileManager.fileExists(atPath: filePath) {
//
//            if let bundlePath = Bundle.main.path(forResource: "gameStats", ofType: "plist"){
//                let result = NSMutableDictionary(contentsOfFile: bundlePath)
//                print("Bundle file gameStats.plist is -> \(result?.description)")
//
//                do{
//                    try fileManager.copyItem(atPath: bundlePath, toPath: filePath)
//                    print("file created")
//                }catch{
//                    print("copy failure.")
//                }
//            }
//
//        } else {
//            readGameStats()
//            print("Stats Loaded")
//        }
//    }
//
//    func setDefaults() {
//
//    }
    
    
//    func readGameStats() {
//        let path = Bundle.main.path(forResource: "gameStats", ofType: "plist")
//        let gameStatsDict: NSDictionary = NSDictionary(contentsOfFile: path!)!
//
//
//        if (gameStatsDict.object(forKey: "Stats") != nil) {
//
//            if let statsDict:[String : Any] = gameStatsDict.object(forKey: "Stats") as? [String : Any] {
//
//                for (key, value) in statsDict {
//
//                    switch key {
//                    case "Milk":
//                        player.milk = value as! Double
//                        print(key,value)
//
//                    case "Butter":
//                        player.butter = value as! Int
//                        print(key,value)
//
//                    case "LuckLevel":
//                        player.luckLevel = value as! Double
//                        print(key,value)
//
//
//                    case "EfficiencyLevel":
//                        player.efficiencyLevel = value as! Double
//                        print(key,value)
//
//                    case "ChurnsDone":
//                        player.churnsDone = value as! Int
//                        print(key,value)
//
//                    default:
//                        print("error loading \(key)")
//                    }
//                }
//
//            }
//        }
//
//    }
//
//
//    func writeStatsToPlist(milkVal: Double, butterVal: Int, luckLevelVal: Double, efficiencyVal: Double, churnsDoneVal: Int) {
//
//        let path = NSHomeDirectory()+"/Documents/gameStats.plist"
//
//        let fileManager = FileManager.default
//
//        //        let bundlePath = Bundle.main.path(forResource: "gameStats", ofType: "plist")
//        if let gameStatsDict = NSMutableDictionary(contentsOfFile: path) {
//
//            gameStatsDict["Milk"] = milkVal
//            gameStatsDict["Butter"] = butterVal
//            gameStatsDict["LuckLevel"] = luckLevelVal
//            gameStatsDict["EfficiencyLevel"] = efficiencyVal
//            gameStatsDict["ChurnsDone"] = churnsDoneVal
//
//            gameStatsDict.write(toFile: path, atomically: true)
//            print("write")
//
//            //            dict.setValue(butterVal, forKey: "Butter")
//            //            dict.setValue(luckLevelVal, forKey: "LuckLevel")
//            //            dict.setValue(efficiencyVal, forKey: "EfficiencyLevel")
//            //            dict.setValue(churnsDoneVal, forKey: "ChurnsDone")
//
//        }
//    }

}

