//
//  FindCowsScene.swift
//  ChurnItUp_Real
//
//  Created by Ben Rohland on 2/20/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//
//The spriteKit that handles visuals for the GetLocationViewController.

import SpriteKit
import GameplayKit

class FindCowsScene: SKScene {
    
    private let CompassNodeName = "compass"
    private let DistanceTextNodeName = "distanceText"
    private let DistanceValNodeName = "distanceValue"
    
    var distanceValue: SKLabelNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        //Create the beardArrow and show it on the screen.
        let compass = SKSpriteNode(imageNamed: "bArrow.png")
        compass.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        if (size.width <= size.height) {
            compass.size = CGSize(width: size.width/2.0, height: size.width/2.0)
        } else {
            compass.size = CGSize(width: size.height/2.0, height: size.height/2.0)
        }
        compass.name = CompassNodeName
        addChild(compass)
        
        let distanceText = SKLabelNode(fontNamed: "AvenirNext-Bold")
        distanceText.position = CGPoint(x: size.width/2.0, y: size.height/4.0)
        distanceText.fontSize = 20.0
        distanceText.fontColor = SKColor.black
        distanceText.name = DistanceTextNodeName
        distanceText.text = "Distance:"
        //distanceText.zPosition = 5.0
        
        addChild(distanceText)
        
        distanceValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        distanceValue.position = CGPoint(x: size.width/2.0, y: size.height/4.5)
        distanceValue.fontSize = 20.0
        distanceValue.fontColor = SKColor.black
        distanceValue.name = DistanceValNodeName
        distanceValue.text = "0 Meters"
        
        addChild(distanceValue)
        
        
        
        
        
        
    }
    
    func updateDistance(_ distance: Double) {
        
        distanceValue.text = "\(distance) Meters"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
