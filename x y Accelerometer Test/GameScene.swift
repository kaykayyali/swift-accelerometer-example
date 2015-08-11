//
//  GameScene.swift
//  x y Accelerometer Test
//
//  Created by Kaysser Kayyali on 1/29/15.
//  Copyright (c) 2015 Kaysser Kayyali. All rights reserved.
//


import CoreMotion
import SpriteKit
class GameScene: SKScene {
   
    let motionManager = CMMotionManager()
    let motion = CMDeviceMotion()
    let background = SKSpriteNode(imageNamed: "background.png")
    let shipThrustersPath:NSString = NSBundle.mainBundle().pathForResource("ShipThrusters", ofType: "sks")!
    let starsPath:NSString = NSBundle.mainBundle().pathForResource("stars", ofType: "sks")!
    let mainShip = SKSpriteNode(imageNamed:"NewShip.png")
    let scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    let shotLabel = SKLabelNode(fontNamed:"Chalkduster")
    let testEnemy = SKSpriteNode(imageNamed: "ShittyShip.png")
    var testEnemyExists:Bool = false
    var shotsOnScreen:[SKSpriteNode] = []
    var shotCounter:Int = 0
    var scoreCounter:Int = 0
    
    
    override func didMoveToView(view: SKView) {
       
       
        self.createBackground()
        self.CreateShip()
        self.physicsBody?.affectedByGravity = false
        var borderBody:SKPhysicsBody  = SKPhysicsBody(edgeLoopFromRect:self.frame);
        self.physicsBody = borderBody
        self.physicsBody?.friction = 0.0
    }
    
   
    
    
    func createBackground(){
       
        

        
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.xScale = 1
        background.yScale = 1
        self.addChild(background)
        let stars = NSKeyedUnarchiver.unarchiveObjectWithFile(starsPath) as SKEmitterNode
        stars.position = CGPointMake((CGRectGetMinX(self.frame)), (CGRectGetMaxY(self.frame) - 0))
        stars.alpha = 0.8
        
        background.addChild(stars)
        
        scoreLabel.text = "\(scoreCounter)"
        scoreLabel.fontSize = 25;
        scoreLabel.position = CGPointMake((CGRectGetMinX(self.frame)  + 450), (CGRectGetMaxY(self.frame) - 525))
        
        background.addChild(scoreLabel)
        
        shotLabel.text = "\(shotCounter)"
        shotLabel.fontSize = 25;
        shotLabel.position = CGPointMake((CGRectGetMinX(self.frame) - 450), (CGRectGetMaxY(self.frame) - 525))
                
        background.addChild(shotLabel)
    }
    
    
    
// Testing only
    func createTestEnemy(){
        var sidesScrollRight = SKAction.moveBy((CGVectorMake(750, 0)), duration: 2.5)
        var sideScrollLeft = SKAction.moveBy((CGVectorMake(-750, 0)), duration: 2.5)
//      println("\(testEnemy.position)")
        if testEnemyExists != true {
            
            testEnemy.xScale = 0.4
            testEnemy.yScale = 0.4
            testEnemy.position = CGPointMake((self.frame.midX + 50), (self.frame.midY + 150))
            
            
            
            self.addChild(testEnemy)
//            testEnemy.runAction(SKAction.moveBy((CGVectorMake(250, 0)), duration: 1))

            
//            testEnemy.physicsBody = SKPhysicsBody(circleOfRadius: testEnemy.size.height / 2.75)
            testEnemy.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 50))
            testEnemyExists = true
            testEnemy.physicsBody?.affectedByGravity = false
            
            
            
            
            
            
            
        }
        //Enemy Movement
//        if self.testEnemy.position.x > 700 && self.testEnemy.hasActions() == false {
//            self.testEnemy.runAction(sideScrollLeft)
//        }
//        if self.testEnemy.position.x < 400 && self.testEnemy.hasActions() == false {
//            self.testEnemy.runAction(sidesScrollRight)
//        }
        
    }
// End Testing
    
    
// Create hero ship
    func CreateShip() {
       let shipThrusters = NSKeyedUnarchiver.unarchiveObjectWithFile(shipThrustersPath) as SKEmitterNode
        mainShip.xScale = 0.07
        mainShip.yScale = 0.07
        mainShip.physicsBody = SKPhysicsBody(circleOfRadius: mainShip.size.height / 2.75)
        mainShip.physicsBody?.affectedByGravity = false
        motionManager.startDeviceMotionUpdates()
        motionManager.accelerometerUpdateInterval = 1.0/10.0
        mainShip.position = CGPointMake((CGRectGetMidX(self.frame)), (CGRectGetMidY(self.frame) - 200))
        self.addChild(mainShip)
        shipThrusters.position = CGPointMake(0,-200)
        mainShip.addChild(shipThrusters)
        
    }
// End ship creation
    
    
    
    
// Basic laser shot
    func ShootLaser(){
        var currentShot = SKSpriteNode(imageNamed: "laser.png")
// init properties
        currentShot.xScale = 0.23
        currentShot.yScale = 0.23
        currentShot.name = toString(shotCounter)
        currentShot.physicsBody = SKPhysicsBody(edgeLoopFromRect:currentShot.frame)
        currentShot.physicsBody?.friction = 0.0
        currentShot.position = CGPointMake((self.mainShip.position.x ), (self.mainShip.position.y + 90))
        
// add to array
        shotsOnScreen.append(currentShot)
       
//add to screen and fire away
        self.addChild(shotsOnScreen[shotCounter])
        self.shotsOnScreen[shotCounter].runAction(SKAction.moveBy(CGVectorMake(0, 800), duration: 1))
        
// keep track of which shot in array of shots is being created
        shotCounter++
    
    
    }
    
// end laser creation
    
    

    
// gravity handling
    func gravityUpdated(){
        if let data = motionManager.deviceMotion {
            let gravity = data.gravity
            self.mainShip.physicsBody?.applyImpulse(CGVectorMake(CGFloat((gravity.y * 20)), CGFloat()))
//            println("x \(gravity.x) and y \(gravity.y) ")
            
        }
    }
// End gravity handling
    

    
    
    //touches handling
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            ShootLaser()
            
        }
    }
    // end touches handling
    
    
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        gravityUpdated()
        createTestEnemy()
        randomMovementGenerator(self.testEnemy)
        
        
        
        
        shotLabel.text = "Shots \(shotCounter)"
        scoreLabel.text = "Kills \(scoreCounter)"
        
        
        
      
        
        
        
        
        if self.testEnemy.position.y > 700 || self.testEnemy.position.y < 0 {
            testEnemy.removeFromParent()
            testEnemyExists = false
            scoreCounter++
        }
        if self.testEnemy.position.x > 1200 || self.testEnemy.position.x < 0 {
            testEnemy.removeFromParent()
            testEnemyExists = false
        }
    }
    
    
    
    
    
    
    
    
    
    
    func randomMovementGenerator(actionableNode:SKNode){
        
        var randomNum = Int(arc4random_uniform(UInt32(5)))
        var selectedAction: SKAction
        
        
       
        
         println("\(randomNum)")
        
        if randomNum == 0 {
            if actionableNode.hasActions() == false {
                selectedAction = SKAction.moveToX(CGFloat(600.0), duration: 1)
                actionableNode.runAction(selectedAction)
                println("\(randomNum)")
            }
         
        }
        
        else if randomNum == 1 {
            if actionableNode.hasActions() == false{
            selectedAction = SKAction.moveToX(CGFloat(20.0), duration: 1)
            actionableNode.runAction(selectedAction)
             println("\(randomNum)")
            }
        }
        
        else if randomNum == 2 {
           if actionableNode.hasActions() == false{
            selectedAction = SKAction.moveToX(CGFloat(800.0), duration: 1)
            actionableNode.runAction(selectedAction)
             println("\(randomNum)")
            }
        }
        
        else if randomNum == 3 {
          if actionableNode.hasActions() == false{
            selectedAction = SKAction.moveToX(CGFloat(400.0), duration: 1)
            actionableNode.runAction(selectedAction)
             println("\(randomNum)")
            }
        }
            
        else if randomNum == 4 {
            if actionableNode.hasActions() == false{
            selectedAction = SKAction.moveToX(CGFloat(200.0), duration: 1)
            actionableNode.runAction(selectedAction)
             println("\(randomNum)")
            }
        }
        
        else {
            selectedAction = SKAction.moveToX(CGFloat(20.0), duration: 1)
            actionableNode.runAction(selectedAction)
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
// End scene
    
    
    
    
    
    
    
    
    
    
    
}