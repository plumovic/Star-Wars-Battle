//
//  GameScene.swift
//  StarWars Battle
//
//  Created by plumovic on 12/1/15.
//  Copyright (c) 2015 plumovic. All rights reserved.
//

import SpriteKit

struct physicsCategory
{
    static let enemy : UInt32 = 1
    static let laser : UInt32 = 2
    static let player : UInt32 = 3
}


class GameScene: SKScene, SKPhysicsContactDelegate
{
 
    var highscore = Int()
    var score = Int()
    var player = SKSpriteNode(imageNamed: "X-Wing")
    var scoreLabel = UILabel()

    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        
        var highscoreDefault = NSUserDefaults.standardUserDefaults()
        if (highscoreDefault.valueForKey("highscore") != nil)
        {
            highscore = highscoreDefault.valueForKey("highscore") as! NSInteger
        }
        else
        {
            highscore = 0
        }
        
        
        physicsWorld.contactDelegate = self
        
        self.scene?.backgroundColor = UIColor.blackColor()
        self.addChild(SKEmitterNode(fileNamed: "RainParticle"))
        
        //gravity for and position for player
        
        player.position = CGPointMake(self.size.width / 2 , self.size.height / 5)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = physicsCategory.player
        player.physicsBody?.contactTestBitMask = physicsCategory.enemy
        player.physicsBody?.dynamic = false
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("SpawnLaser"), userInfo: nil, repeats: true)
        var enemyTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("spawnEnemies"), userInfo: nil, repeats: true )
        self.addChild(player)
        
        scoreLabel.text = "\(score)"
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        scoreLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        scoreLabel.textColor = UIColor.yellowColor()
        self.view?.addSubview(scoreLabel)
       
    }
    
    // the begining of setting the physics to everything and everybody
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        var firstBody : SKPhysicsBody = contact.bodyA
        var secondBody : SKPhysicsBody = contact.bodyB
        
        
        if ((firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.laser)) ||
            ((firstBody.categoryBitMask == physicsCategory.laser) && (secondBody.categoryBitMask == physicsCategory.enemy))
        {
            collideWithLaser(firstBody.node as! SKSpriteNode, laser: secondBody.node as! SKSpriteNode)
        }
            
            
        else if ((firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.player)) ||
            ((firstBody.categoryBitMask == physicsCategory.player) && (secondBody.categoryBitMask == physicsCategory.enemy))
        {
            collideWithPerson(firstBody.node as! SKSpriteNode, person: secondBody.node as! SKSpriteNode)
        }
        
        
        
    }
    
    // function when the laser collides with the enemy
    
    func collideWithLaser(enemy: SKSpriteNode , laser: SKSpriteNode)
    {
        
        // removes the laser and the enemy when the laser hits the enemy and addds 1 to the score label
        
        enemy.removeFromParent()
        laser.removeFromParent()
        score++
        scoreLabel.text = "\(score)"
    }
    
    
    // function for when you contact a enemy and die and lose the game
    
    func collideWithPerson(enemy: SKSpriteNode, person: SKSpriteNode)
    {
        
        // sets the default score
        
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        //score.setValue(score, forKey: "score")
        scoreDefault.synchronize()
        
        // sets the highscore and score
        
        if (score > highscore)
        {
            var highscoreDefault = NSUserDefaults.standardUserDefaults()
            highscoreDefault.setValue(score, forKey: "highscore")
        }
        
        // removes everything from the scene when you die
        
        enemy.removeFromParent()
        person.removeFromParent()
        self.view?.presentScene(EndScene())
        scoreLabel.removeFromSuperview()
    }
    
    
    
    // function for spawning the laser and the physics for the laser
    
    func SpawnLaser()
    {
        
        // creates a laser object that is a sprite. sets the motion to every laser to go up and runs the action.
        
        var laser = SKSpriteNode(imageNamed: "Red_laser")
        let action = SKAction.moveToY(self.size.height + 30, duration: 1)
        let actionDone = SKAction.removeFromParent()
        laser.runAction(SKAction.sequence([action, actionDone]))
        
        // sets the postion of the laser. also sets the gravity to the laser which is 0.
        
        laser.zPosition = -5
        laser.position = CGPointMake(player.position.x, player.position.y)
        laser.physicsBody = SKPhysicsBody(rectangleOfSize: laser.size)
        laser.physicsBody?.categoryBitMask = physicsCategory.laser
        laser.physicsBody?.contactTestBitMask = physicsCategory.enemy
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.dynamic = false
        
        // adds the laser to the scene
        
        self.addChild(laser)
    }
    
    // function to spawn enemies
    
    func spawnEnemies()
    {
        
        // make an object named enemy as a sprite. setting its width, height and position.
        
        var enemy = SKSpriteNode(imageNamed: "Tie-Fighter")
        var minValue = self.size.width / 8
        var maxValue = self.size.height - 20
        var spawnPoint = UInt32(maxValue - minValue)
        
        // sets the motion to the object to move down and runs the action and when it hits the bottom of the screen removes the object
        
        let action = SKAction.moveToY(-30, duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([action, actionDone]))
        
        // Laser position and physics. Gravity for the laser and enemy
        
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)),y: self.size.height)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = physicsCategory.laser
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.dynamic = true
        
        // adds the laser to the scene
        
        self.addChild(enemy)
    }
    
    // function to detect when you first begin to touch the screen
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>)
        {
            let location = touch.locationInNode(self)
            player.position.x = location.x
        }
    }
    
    // function to detect wether or not you are still holding the screen
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        for touch in (touches as! Set<UITouch>)
        {
            let location = touch.locationInNode(self)
            player.position.x = location.x
    }
        
        // function to update the scene every .001 seconds
    
     func update(currentTime: CFTimeInterval)
    {
        
    }
    }
}