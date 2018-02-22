//
//  FindCowsScene.swift
//  ChurnItUp_Real
//
//  Created by Ben Rohland on 2/20/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import SpriteKit
import GameplayKit

class FindCowsScene: SKScene {
    
    private let CompassNodeName = "compass"
    // private let BackgroundNodeName = "background"
    
    override init(size: CGSize) {
        super.init(size: size)
        
        //self.backgroundColor = UIColor(cgColor: cgWhite)
        
        let compass = SKSpriteNode(imageNamed: "bArrow.png")
        compass.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        //compass.texture = SKTexture(imageNamed: "bArrow.png")
        //compass.anchorPoint = CGPoint(x: size.width/2.0, y: size.height/2.0)
        if (size.width <= size.height) {
            compass.size = CGSize(width: size.width/2.0, height: size.width/2.0)
        } else {
            compass.size = CGSize(width: size.height/2.0, height: size.height/2.0)
        }
        compass.name = CompassNodeName
        addChild(compass)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
