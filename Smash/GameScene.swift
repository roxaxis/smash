import UIKit
import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate{
    
    var life = 3
    var leftSideTouched  = true
    var rightSideTouched = false
    
    
    var scoreLabel   = SKLabelNode()
    var RightBullet = SKSpriteNode()
    var LeftBullet  = SKSpriteNode()
    var Enemy       = SKSpriteNode()
    var Enemy2      = SKSpriteNode()
    var explosionSound  = SKAction()
    var DownBoundry =       SKNode()
    
    override func didMove(to view: SKView) {
        
        let num = randomizer_Int(1, upper: 15)

        explosionSound = SKAction.playSoundFileNamed("explosion sounds/Explosion\(num).wav", waitForCompletion: false)
        
        DownBoundry.position = CGPoint(x: 0, y: 0)
        DownBoundry.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        DownBoundry.physicsBody?.categoryBitMask = PhysicsCategory.DownBorder
        DownBoundry.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        DownBoundry.physicsBody?.collisionBitMask = PhysicsCategory.None
        DownBoundry.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(DownBoundry)
        
        self.backgroundColor = UIColor.white
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        //arka planı getirir döngü halinde
        //makeBackground()
        
        scoreLabel.text = "0"
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 60
        let screenwidth = self.frame.size.width
        let screenheight = self.frame.size.height
        scoreLabel.position = CGPoint(x: screenwidth / 2,  y: screenheight / 1.25)
        self.addChild(scoreLabel)
        
        makeEnemy()
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(makeEnemy),
                SKAction.wait(forDuration: 1.0)
                ])
            ))

        
}
    
    func makeBackground(){
        
        let bgTexture = SKTexture(imageNamed: "background.gif")
        
        let moveBg = SKAction.move(by: CGVector(dx: 0, dy: -bgTexture.size().width), duration: 6)
        let replaceBg = SKAction.move(by: CGVector(dx: 0, dy: bgTexture.size().width), duration: 0)
        _ = SKAction.repeatForever(SKAction.sequence([moveBg,replaceBg]))
        
        let bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        bg.size.width = self.frame.width
        bg.size.height = self.frame.height
        self.addChild(bg)
        
         /*for var i:CGFloat=0; i<3; i++ {
            
            var bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: CGRectGetMidY(self.frame), y: bgTexture.size().width/2 + bgTexture.size().width * i)
            bg.size.width = self.frame.width
            
            
            bg.runAction(moveBgForever)
            self.addChild(bg)

            
        } */
        
        
        
        
    }
    
    func makeEnemy() {
        //Enemy = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(50, 50))
        //Enemy.texture = SKTexture(imageNamed: "enemy.png")
        
        
        
        let enemyAnimatedAtlas = SKTextureAtlas(named: "walkAnim")
        
        var AnimationFrames = [SKTexture]()
        
        var BearWalkingFrames : [SKTexture]!
        
        let numImages = enemyAnimatedAtlas.textureNames.count
        
        var i = 1
        
        while (i <= numImages) {
            let expTextureName = "slice\(i).png"
            AnimationFrames.append(enemyAnimatedAtlas.textureNamed(expTextureName))
            i += 1
        }
        
        BearWalkingFrames = AnimationFrames
        
        let firstFrame = AnimationFrames[0]
        Enemy = SKSpriteNode(texture: firstFrame)
        Enemy.physicsBody = SKPhysicsBody(rectangleOf: Enemy.size)
        Enemy.physicsBody?.isDynamic = true
        Enemy.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        Enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        Enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        let spawnX = random(min: self.frame.size.width / 3 , max: self.frame.size.width / 1.5)
        let spawnPoint = CGPoint(x: spawnX, y: randomizer(400, upper: 500))
        let actualDuration = randomizer(2, upper: 4)
        Enemy.position = spawnPoint
        
        self.addChild(Enemy)
        
        let expanimatior = SKAction.animate(with: BearWalkingFrames, timePerFrame:5 / 60)
        
        let EnemyMoveAnimation = SKAction.move(to: CGPoint(x: spawnX, y: -Enemy.size.width/2), duration: TimeInterval(CGFloat(5)))
        
        let groupAction = SKAction.group([expanimatior, EnemyMoveAnimation])
        Enemy.run(groupAction)
    }
    
    func explodeAnimation(_ animatePositionNode: SKSpriteNode ) {
        let explosionAnimatedAtlas = SKTextureAtlas(named: "explosion")
        
        var AnimationFrames = [SKTexture]()
        
        var BearWalkingFrames : [SKTexture]!
        
        let numImages = explosionAnimatedAtlas.textureNames.count
        
        var i = 1
        while( i <= numImages) {
            let expTextureName = "slice\(i).png"
            AnimationFrames.append(explosionAnimatedAtlas.textureNamed(expTextureName))
            i += 1
        }
        
        BearWalkingFrames = AnimationFrames
        
        let firstFrame = AnimationFrames[0]
        let Explode = SKSpriteNode(texture: firstFrame)
        Explode.position = animatePositionNode.position
        self.addChild(Explode)
        
        let expanimatior = SKAction.animate(with: BearWalkingFrames, timePerFrame: 0.07)
        Explode.run(expanimatior, completion: {Explode.removeFromParent()})
    }
    
    func projectileDidCollideWithMonster(_ bullet:SKSpriteNode, enemy:SKSpriteNode) {
        Global_Variables.score += 1
        scoreLabel.text = "\(Global_Variables.score)"
        
        self.run(explosionSound)
        explodeAnimation(enemy)
        
        bullet.removeFromParent()
        enemy.removeFromParent()
    }
    
    func monsterDidCollideWithBorder() {
        print("border contact")
    }
    
    //CONTACT MANAGEMENT
    func didBegin(_ contact: SKPhysicsContact) {
        
                // 1
                var firstBody: SKPhysicsBody
                var secondBody: SKPhysicsBody
                if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                    firstBody = contact.bodyA
                    secondBody = contact.bodyB
                } else {
                    firstBody = contact.bodyB
                    secondBody = contact.bodyA
                }
                
                // 2
                if ((firstBody.categoryBitMask & PhysicsCategory.Monster  != 0) &&
                    (secondBody.categoryBitMask & PhysicsCategory.Projectile  != 0))  {
                        
                        if (firstBody.categoryBitMask == PhysicsCategory.DownBorder) || (secondBody.categoryBitMask == PhysicsCategory.DownBorder) {
                            if let view = view {
                                let scene = GameOverScene.unarchiveFromFile("GameOverScene") as! GameOverScene
                                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.5)
                                view.presentScene(scene, transition: transition)
                                
                                
                                
                            }

                        }
                        
                        else {
                        projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
                        }
                
                }

        
        
        
    }
    
    //TOUCH MANAGEMENT
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            
        for touch in (touches as Set<UITouch>) {
            
            let location = touch.location(in: self)
            
            
            //Sol taraf
            
            if (rightSideTouched == true) {
            
            if (location.x < self.frame.width/3){
                leftSideTouched = true
                rightSideTouched = false
                
                LeftBullet = SKSpriteNode(color: UIColor.red, size: CGSize(width: 40, height: 10))
                LeftBullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 10))
                LeftBullet.physicsBody?.isDynamic = true
                LeftBullet.physicsBody?.usesPreciseCollisionDetection = true

                LeftBullet.position = location
                LeftBullet.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
                LeftBullet.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
                LeftBullet.physicsBody?.collisionBitMask = PhysicsCategory.None
                
                self.addChild(LeftBullet)
                
                let actionMove = SKAction.move(to: CGPoint(x: 2500, y: location.y), duration: 1)
                let actionMoveDone = SKAction.removeFromParent()
                LeftBullet.run(SKAction.sequence([actionMove, actionMoveDone]))
                
                }
            }
            //sağ taraf
            if (leftSideTouched == true) {
            
            if (location.x > self.frame.width/1.5) {
                rightSideTouched = true
                leftSideTouched = false
                
                RightBullet = SKSpriteNode(color: UIColor.red, size: CGSize(width: 40, height: 10))
                RightBullet.physicsBody = SKPhysicsBody(rectangleOf: RightBullet.size)
                RightBullet.physicsBody?.isDynamic = true
                RightBullet.physicsBody?.usesPreciseCollisionDetection = true
              
                RightBullet.position = location
                RightBullet.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
                RightBullet.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
                RightBullet.physicsBody?.collisionBitMask = PhysicsCategory.None
                self.addChild(RightBullet)
                
                let actionMove = SKAction.move(to: CGPoint(x: -2500, y: location.y), duration: 1)
                let actionMoveDone = SKAction.removeFromParent()
                RightBullet.run(SKAction.sequence([actionMove, actionMoveDone]))
                
                
                }
            }
           
        }
    }
}





