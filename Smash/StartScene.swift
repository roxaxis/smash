import UIKit
import SpriteKit

class StartScene: SKScene {
    
    var startButton = SKNode()
    var gameCenterButton = SKNode()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let bgTexture = SKTexture(imageNamed: "background.gif")
        let bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        bg.size.width = self.frame.width
        bg.size.height = self.frame.height
        self.addChild(bg)
        
        
        
        startButton = childNode(withName: "playButton")!
        startButton.zPosition = 10
        
        gameCenterButton = childNode(withName: "gameCenter")!
        gameCenterButton.zPosition = 10
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches as Set<UITouch>) {
            
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode == startButton {
            
            Global_Variables.score = 0
            
                
            if let view = view {
            let scene = GameScene.unarchiveFromFile("GameScene") as! GameScene
            let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.5)
            view.presentScene(scene, transition: transition)
            }
                
                if touchedNode == gameCenterButton {
                    //let a: GameViewController = GameViewController()
                    //a.showLeader()
            }
        }
    }
}
}
