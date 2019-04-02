////
////  Rocket.swift
////  WWDC19
////
////  Created by Aaron Cheung 430 on 16/3/2019.
////  Copyright © 2019 Aaron Cheung 430. All rights reserved.
////

import Foundation
import SceneKit
import ARKit

public class Rocket : SCNNode {
    
    private var scene :SCNScene!
    
    public init(scene :SCNScene) {
        
        super.init()
        self.scene = scene
        
        setup()
    }
    
    public init(rocketNode :SCNNode) {
        super.init()
        
        // self.missileNode = missileNode
        
        setup()
    }
    
    private func setup() {
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        guard let rocketNode = self.scene.rootNode.childNode(withName: "rocketNode", recursively: true),
            let smokeNode = self.scene.rootNode.childNode(withName: "smokeNode", recursively: true)
            else {
                fatalError("Node not found!")
        }
        
        let smoke = SCNParticleSystem(named: "art.scnassets/smoke.scnp", inDirectory: nil)
        smokeNode.addParticleSystem(smoke!)
        
        self.addChildNode(rocketNode)
        self.addChildNode(smokeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
