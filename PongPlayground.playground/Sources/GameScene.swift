import Foundation
import PlaygroundSupport
import SpriteKit

public struct PhysicsCategory {
    static let GoalCategory : UInt32 = 0x1 << 1
    static let BallCategory : UInt32 = 0x1 << 2
}

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var paddle : SKShapeNode?
    private var ball : SKShapeNode?
    private var court, goal : SKNode?
    public override func didMove(to view: SKView) {

        //A Ball
        ball = SKShapeNode(circleOfRadius: 25)
        ball?.position = CGPoint(x:0,y:0)
        ball?.fillColor = UIColor.white
        ball?.physicsBody = SKPhysicsBody(circleOfRadius:25)
        ball?.physicsBody?.affectedByGravity = false
        ball?.physicsBody?.velocity.dy = 500
        ball?.physicsBody?.velocity.dx = 250
        ball?.physicsBody?.density = 100.0
        ball?.physicsBody?.linearDamping = 0.0
        ball?.physicsBody?.angularDamping = 0.0
        ball?.physicsBody?.friction = 0.0
        ball?.physicsBody?.restitution = 1.0
        addChild(ball!)

        //A Paddle
        let paddleWidth = ((view.scene?.size.width)!/4)
        let paddleX = -((view.scene?.size.width)!/4)/2
        let paddleHeight = ((view.scene?.size.height)! * 0.05)
        
        let originPaddleY = (-1*(view.scene?.size.height)!/2) + paddleHeight
        let paddleOffset = paddleHeight / 2
        
        paddle = SKShapeNode(rect: CGRect(x: paddleX, y: originPaddleY - paddleOffset, width:paddleWidth, height: paddleHeight))
        paddle?.fillColor = UIColor.white
        paddle?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: paddleWidth, height: paddleHeight), center:CGPoint(x: 0, y: originPaddleY))
        paddle?.physicsBody?.affectedByGravity = false
        paddle?.physicsBody?.isDynamic = false
        paddle?.physicsBody?.density = 100.0
        addChild(paddle!)
        
        //A Court
        court = SKNode()
        court?.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x:-((view.scene?.size.width)!/2), y: -((view.scene?.size.height)!/2), width: (view.scene?.size.width)!, height: (view.scene?.size.height)!))
        court?.physicsBody?.density = 100.0
        addChild(court!)
        
        //A Goal
        goal = SKNode()
        let goalY : CGFloat = -1 * (view.scene?.size.height)!/2 + 2
        let edgeFrom : CGPoint = CGPoint(x:-1*(view.scene?.size.width)!/2, y: goalY)
        let edgeTo : CGPoint = CGPoint(x:(view.scene?.size.width)!/2, y: goalY)
        goal?.physicsBody = SKPhysicsBody(edgeFrom: edgeFrom, to: edgeTo)
        goal?.physicsBody?.categoryBitMask = PhysicsCategory.GoalCategory
        goal?.physicsBody?.contactTestBitMask = PhysicsCategory.BallCategory
        addChild(goal!)
    }
    
    override public func sceneDidLoad(){
        self.physicsWorld.contactDelegate = self
    }
    
    public func didBegin(_ contact:SKPhysicsContact) {
        print("deteccted contact")
    }
    
    public func touchDown(atPoint pos : CGPoint) {

    }
    
    public func touchMoved(toPoint pos : CGPoint) {
        paddle!.position.x = pos.x
    }
    
    public func touchUp(atPoint pos : CGPoint) {

    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
