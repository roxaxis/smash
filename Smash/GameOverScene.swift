import UIKit
import SpriteKit


var ReplayButton = SKSpriteNode()


class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.black
        
        //Replay Button
        
        ReplayButton = SKSpriteNode(imageNamed: "Replay.png")
        ReplayButton.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        self.addChild(ReplayButton)
        
        //Final Score
        let FinalScoreLabel = SKLabelNode()
        FinalScoreLabel.text = "\(Global_Variables.score)"
        FinalScoreLabel.fontName = "Helvetica"
        FinalScoreLabel.fontSize = 30
        FinalScoreLabel.fontColor = UIColor.blue
        FinalScoreLabel.position = CGPoint(x: 100, y: 100)
        self.addChild(FinalScoreLabel)
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches as Set<UITouch>) {
            
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode == ReplayButton {
               
                
                
                
                if let view = view {
                    let scene = GameScene.unarchiveFromFile("GameScene") as! GameScene
                    Global_Variables.score = 0
                    let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.5)
                    view.presentScene(scene, transition: transition)
                
                
                
            }
            
            
        }
    }
}

}

