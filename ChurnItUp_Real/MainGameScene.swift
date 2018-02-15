//
//  MainGameScene.swift
//  ChurnItUp_Real
//
//  Created by Ben Rohland on 2/14/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainGameScene: SKScene {
    
    private let ChurnStaffNodeName = "staff"
    private let ChurnBaseNodeName = "base"
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let staff = SKSpriteNode(imageNamed: "churnStaff.png")
        
        let base = SKSpriteNode(imageNamed: "churnBase.png")
        
        
        staff.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
