//
//  ViewController.swift
//  McBalance
//
//  Created by Jakup Güven on 2019-01-15.
//  Copyright © 2019 Jakup Güven. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion
import CoreFoundation

class ViewController: UIViewController, SKSceneDelegate, SKPhysicsContactDelegate{
    @IBOutlet var mainView: SKView!
    let motionManager = CMMotionManager()
    var playerNode : SKSpriteNode!
    var foodNode : SKSpriteNode!
    var gameScene : SKScene!
    let screenRect = UIScreen.main.bounds
    var difficulty = 4.0
    var score : UInt64 = 0

    override func viewDidLoad() {
        mainView.bounds = screenRect
        super.viewDidLoad()
        initGameScene()
        initPlayerNode()
        initFoodNode()
        mainView.presentScene(gameScene)
        motionManager.startAccelerometerUpdates()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        difficulty += 1.0
        score += 1
        foodNode.removeFromParent()
        initFoodNode()
        
    }
    
    
    
    
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        if playerNode.position.x + playerNode.size.width / 16 > mainView.frame.width {
            playerNode.position.x = playerNode.size.width / 16
        }
        else if playerNode.position.x + playerNode.size.width / 16 < 0 {
            playerNode.position.x = mainView.frame.width - playerNode.size.width / 16
        }
        
        if playerNode.position.y + playerNode.size.height / 16 > mainView.frame.height {
            playerNode.position.y = playerNode.size.height / 16
        }
        else if playerNode.position.y + playerNode.size.height / 16 < 0 {
            playerNode.position.y = mainView.frame.height - playerNode.size.height / 16
        }
        
        if let accelerometerData = motionManager.accelerometerData {
            scene.physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * difficulty, dy: accelerometerData.acceleration.y * difficulty)
        }
    }
    
    func initGameScene(){
        gameScene = SKScene(size: mainView.bounds.size)
        gameScene.anchorPoint = CGPoint(x: 0, y: 0)
        gameScene.delegate = self
        gameScene.physicsWorld.contactDelegate = self
        
    }
    
    func initPlayerNode(){
        playerNode = SKSpriteNode(imageNamed: "small_green_square")
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.physicsBody?.contactTestBitMask = 0b1111
        playerNode.physicsBody?.collisionBitMask = 0b0001
        playerNode.physicsBody?.categoryBitMask = 0b0001


        gameScene.addChild(playerNode)
    }
    
    func initFoodNode(){
        foodNode = SKSpriteNode(imageNamed: "small_yellow_square")
        foodNode.physicsBody = SKPhysicsBody(rectangleOf: foodNode.size)
        foodNode.physicsBody?.isDynamic = false
        foodNode.physicsBody?.usesPreciseCollisionDetection = true
        foodNode.physicsBody?.contactTestBitMask = 0b1111
        foodNode.physicsBody?.collisionBitMask = 0b0010
        foodNode.physicsBody?.categoryBitMask = 0b0010

        foodNode.position.x = CGFloat(Int.random(in: 0 ..< Int(gameScene.frame.width)))
        foodNode.position.y = CGFloat(Int.random(in: 0 ..< Int(gameScene.frame.height)))
        gameScene.addChild(foodNode)
    }
    
    //Sets a hard border around the frame of the game
    func setBorder(){
        let border = SKPhysicsBody(edgeLoopFrom: gameScene.frame)
        border.friction = 0
        gameScene.physicsBody = border
    }


}

