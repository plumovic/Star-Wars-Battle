//
//  EndScene.swift
//  StarWars Battle
//
//  Created by plumovic on 12/1/15.
//  Copyright (c) 2015 plumovic. All rights reserved.


import Foundation
import SpriteKit
    


class EndScene : SKScene
{
    var restartButton : UIButton!
    var highscore : Int!
    var scoreLabel : UILabel!
    var gameOverLabel : UILabel!
    
    override func didMoveToView(view: SKView)
    {

        scene?.backgroundColor = UIColor.blackColor()
        restartButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 30))
        restartButton.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 7)
        
        restartButton.setTitle("Restart", forState: UIControlState.Normal)
        restartButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
        restartButton.addTarget(self, action: Selector("restart"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(restartButton)
        
        
        gameOverLabel = UILabel(frame: CGRect(x: 145, y: 100, width: 200, height: 200))
        gameOverLabel.text = "Game Over!"
        gameOverLabel.textColor = UIColor.yellowColor()
        gameOverLabel.backgroundColor = UIColor.blackColor()
        self.view?.addSubview(gameOverLabel)

        var scoreDefault = NSUserDefaults.standardUserDefaults()
        var score = scoreDefault.integerForKey("Score")
        
        var highscoreDefault = NSUserDefaults.standardUserDefaults()
        highscore = highscoreDefault.integerForKey("highscore")
        
        scoreLabel = UILabel(frame: CGRect(x: 150, y: 50, width: view.frame.size.width / 3, height: 30))
        scoreLabel.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 4)
        scoreLabel.textColor = UIColor.blueColor()
        scoreLabel.text = "\(score)"
        self.view?.addSubview(scoreLabel)
        
        
    }
    
    
    
    
    
    func restart()
    {
        restartButton.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        gameOverLabel.removeFromSuperview()
        self.view?.presentScene(GameScene())
    }
}
