//
//  MainGameScene.swift
//  ChurnItUp_Real
//
//  Created by Ben Rohland on 2/14/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//
//This is the spriteKit scene that handles the MainScreenViewController's visual aspects.

import SpriteKit
import GameplayKit

class MainGameScene: SKScene {
    
    private let ChurnStaffNodeName = "staff"
    private let ChurnBaseNodeName = "base"
    private let BackgroundNodeName = "background"
    private let MilkNodeName = "milk"
    private let JarNodeName = "jar"
    private let ButterImageNodeName = "butterImage"
    private let ButterValueNodeName = "butterValue"
    private let ChurnsNumberNodeName = "churnsNumber"
    var staffIsUp = true
    var churnsNumber: SKLabelNode!
    var butterText: SKLabelNode!
    var milk: SKSpriteNode!
    var oneHundredPercent: CGFloat!
    var staff: SKSpriteNode!
    
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func start() {
        //Relative height of the milk jar filled to the top.
        oneHundredPercent = CGFloat((size.width / 5) * 1.33)
        
        //Set the background to the barn.
        let background = SKSpriteNode()
        background.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        background.texture = SKTexture(imageNamed: "barn.png")
        background.aspectFillToSize(fillSize: size)
        background.zPosition = 0.0
        background.name = BackgroundNodeName
        addChild(background)
        
        // Show the base of the butter churn.
        let base = SKSpriteNode(imageNamed: "churnBase.png")
        base.position = CGPoint(x: size.width/2.0, y: size.height/4.0)
        base.size = CGSize(width: size.width/3.0, height: (size.width/3.0)*1.93)
        base.zPosition = 2.0
        base.name = ChurnBaseNodeName
        addChild(base)
        
        // Show the butter churn's staff.
        staff = SKSpriteNode(imageNamed: "churnStaff.png")
        staff.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        staff.size = CGSize(width: base.size.width/10.0, height: base.size.height*1.5)
        staff.zPosition = 1.0
        staff.name = ChurnStaffNodeName
        addChild(staff)
        
        //Show the milk jar.
        let jar = SKSpriteNode(imageNamed: "MilkJar.png")
        jar.size = CGSize(width: size.width/5.0, height: (size.width/5.0)*1.33)
        jar.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        jar.position = CGPoint(x: jar.size.width, y: (size.height*0.75)-jar.size.height/2)
        jar.zPosition = 4.0
        jar.name = JarNodeName
        addChild(jar)
        
        //Show the milk inside the milk jar.
        milk = SKSpriteNode(imageNamed: "Milk.png")
        milk.size = CGSize(width: size.width/5.0, height: oneHundredPercent * Player.player.getMilkPercent())
        milk.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        milk.position = CGPoint(x: milk.size.width, y: (size.height*0.75)-jar.size.height/2)
        milk.zPosition = 3.0
        milk.name = MilkNodeName
        addChild(milk)
        
        //Show the butter icon
        let butter = SKSpriteNode(imageNamed: "cuteButter.png")
        butter.size = CGSize(width: size.width/5.0, height: (size.width/5.0)*0.79)
        butter.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        butter.position = CGPoint(x: size.width-butter.size.width, y: jar.position.y+jar.size.height)
        butter.zPosition = 3.0
        
        addChild(butter)
        
        //Show the amount of butter label
        butterText = SKLabelNode(fontNamed: "AvenirNext-Bold")
        butterText.fontSize = 20.0
        butterText.position = CGPoint(x: size.width-butter.size.width, y: butter.position.y-(butter.size.height*1.5))
        butterText.text = String(Player.player.butter)
        butterText.name = ButterValueNodeName
        
        addChild(butterText)
        
        //Show the amount of churns done.
        churnsNumber = SKLabelNode(fontNamed: "AvenirNext-Bold")
        churnsNumber.fontSize = 20.0
        churnsNumber.position = CGPoint(x: base.position.x, y: base.position.y)
        churnsNumber.name = ChurnsNumberNodeName
        churnsNumber.zPosition = 5.0
        churnsNumber.text = "0"
        
        addChild(churnsNumber)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Move the staff up or down when the device is being shaken.
     func moveStaff() {
        
        if staffIsUp {
            
            staff.size.height = staff.size.height/2
            staffIsUp = false
            
        } else {
            
            staff.size.height = staff.size.height*2
            staffIsUp = true
            
        }
        
    }
    
    // Update string values of variables that could have changed.
    func updateHUD() {
    
        
        butterText.text = String(Player.player.butter)
        
        milk.size = CGSize(width: size.width/5.0, height: oneHundredPercent * Player.player.getMilkPercent())
    
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
