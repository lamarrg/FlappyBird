//
//  GameScene.swift
//  FlappyBird
//
//  Created by Lamar Greene on 1/30/16.
//  Copyright (c) 2016 Lamar Greene. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var pipe1 = SKSpriteNode()
    
    var pipe2 = SKSpriteNode()
    
    enum ColliderType: UInt32 {
    
        case Bird = 1
        case Object = 2
        
    }
    
    var gameOver = false
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        let bgTexture = SKTexture(imageNamed: "bg.png")

        let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        
        for var i: CGFloat = 0; i<3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            
            bg.size.height = self.frame.height
            
            bg.runAction(movebgForever)
            
            bg.zPosition = 1
            
            self.addChild(bg)
            
            
        }
        
        

        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
    
        
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        bird.runAction(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        bird.physicsBody!.dynamic = true  // applies gravity
        
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        
        
        bird.zPosition = 3
        
        self.addChild(bird)
        
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody!.dynamic = false
        
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        

        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "makePipes", userInfo: nil, repeats: true)
        
        

    }
    
    func makePipes() {
    
        let gapHeight = bird.size.height * 4
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.width / 100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        
        var pipeTexture = SKTexture(imageNamed: "pipe1.png")
        var pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeTexture.size().height/2 + gapHeight / 2 + pipeOffset)
        pipe1.runAction(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture.size())
        
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.dynamic = false
        
        
        self.addChild(pipe1)
        
        var pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        var pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height/2 - gapHeight / 2 + pipeOffset)
        pipe2.runAction(moveAndRemovePipes)
        
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2Texture.size())
        pipe2.physicsBody!.dynamic = false
        
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        
        
        self.addChild(pipe2)

        pipe1.zPosition = 2
        pipe2.zPosition = 2
    
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        print("we have contact")
        
        gameOver = true
        
        self.speed = 0
    
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        if gameOver == false {
        
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            bird.physicsBody!.applyImpulse(CGVectorMake(0, 49))
        
        }
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
