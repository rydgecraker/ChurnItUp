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
    private let BackgroundNodeName = "background"
    
    var player: Player!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let background = SKSpriteNode()
        background.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        //background.size = CGSize(width: size.width, height: size.height)
        background.texture = SKTexture(imageNamed: "barn.png")
        background.aspectFillToSize(fillSize: size)
        background.zPosition = 0.0
        background.name = BackgroundNodeName
        addChild(background)
        
        let baseSize = CGSize(width: size.width/2.0, height: size.height/2.0)
        let base = SKSpriteNode(imageNamed: "churnBase.png")
        base.position = CGPoint(x: size.width/2.0, y: size.height/4.0)
        //base.size = CGSize(width: size.width/2.0, height: 91.50)
        base.aspectFillToSize(fillSize: baseSize)
        base.zPosition = 2.0
        base.name = ChurnBaseNodeName
        addChild(base)
        
        //let staffSize = CGSize(width: ((size.width/2.0)/11.85), height: size.height/2.0)
        let staff = SKSpriteNode(imageNamed: "churnStaff.png")
        staff.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        staff.size = CGSize(width: base.size.width/10.0, height: base.size.height*1.5)
        //staff.aspectFillToSize(fillSize: staffSize)
        staff.zPosition = 1.0
        staff.name = ChurnStaffNodeName
        addChild(staff)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKSpriteNode {
    
    func aspectFillToSize(fillSize: CGSize) {
        
        if texture != nil {
            self.size = texture!.size()
            
            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width /  self.texture!.size().width
            
            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio
            
            self.setScale(scaleRatio)
        }
    }
    
}
