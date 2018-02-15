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
        
        let base = SKSpriteNode(imageNamed: "churnBase.png")
        
        base.position = CGPoint(x: size.width/2.0, y: size.height/4.0)
        
        base.size = CGSize(width: size.width/2.0, height: 91.50)
        
        base.zPosition = 100.0
        
        base.name = ChurnBaseNodeName
        
        addChild(base)
        
        let staff = SKSpriteNode(imageNamed: "churnStaff.png")
        
        staff.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        
        staff.size = CGSize(width: 4.00, height: 117.30)
        
        staff.name = ChurnStaffNodeName
        
        addChild(staff)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
