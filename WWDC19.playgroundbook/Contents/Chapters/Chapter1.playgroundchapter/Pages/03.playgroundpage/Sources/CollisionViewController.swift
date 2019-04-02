////
////  CollisionViewController.swift
////  WWDC19
////
////  Created by Aaron Cheung 430 on 18/3/2019.
////  Copyright © 2019 Aaron Cheung 430. All rights reserved.
////
import UIKit
import PlaygroundSupport
import ARKit
import SceneKit

enum TrackStatus {
    case added
    case notAdded
}

enum BodyType : Int {
    case car1 = 1
    case car2 = 2
}

public class CollisionViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate {

    public var sceneView: ARSCNView!
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var planes = [OverlayPlane]()
    
    private var BackgroundView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private var trackStatus :TrackStatus = .notAdded

    public override func loadView() {

        sceneView = ARSCNView()
        sceneView.delegate = self

        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene

        sceneView.session.delegate = self
        sceneView.debugOptions = [ ARSCNDebugOptions.showFeaturePoints ]
        sceneView.scene.physicsWorld.contactDelegate = self

        self.view = sceneView

        sceneView.autoenablesDefaultLighting = true

        registerGestureRecognizers()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Enable automatic environment texturing
        //configuration.environmentTexturing = .automatic

        sceneView.session.run(configuration)
        
        self.BackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.BackgroundView)
        self.view.addSubview(self.startLabel)
        
        let startLabelleftMarginConstraint = NSLayoutConstraint(item: self.startLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let startLabelrightMarginConstraint = NSLayoutConstraint(item: self.startLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let startLabelcenterXConstraint = NSLayoutConstraint(item: self.startLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let startLabelcenterYConstraint = NSLayoutConstraint(item: self.startLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        let startLabelheightConstraint = NSLayoutConstraint(item: self.startLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200)
        self.view.addConstraints([startLabelleftMarginConstraint, startLabelrightMarginConstraint, startLabelcenterXConstraint, startLabelcenterYConstraint, startLabelheightConstraint])
        
        let BackgroundViewleftMarginConstraint = NSLayoutConstraint(item: self.BackgroundView, attribute: .left, relatedBy: .equal, toItem: self.startLabel, attribute: .left, multiplier: 1, constant: 0)
        let BackgroundViewrightMarginConstraint = NSLayoutConstraint(item: self.BackgroundView, attribute: .right, relatedBy: .equal, toItem: self.startLabel, attribute: .right, multiplier: 1, constant: 0)
        let BackgroundViewtopMarginConstraint = NSLayoutConstraint(item: self.BackgroundView, attribute: .top, relatedBy: .equal, toItem: self.startLabel, attribute: .top, multiplier: 1, constant: 0)
        let BackgroundViewbottomMarginConstraint = NSLayoutConstraint(item: self.BackgroundView, attribute: .bottom, relatedBy: .equal, toItem: self.startLabel, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([BackgroundViewleftMarginConstraint, BackgroundViewrightMarginConstraint, BackgroundViewtopMarginConstraint, BackgroundViewbottomMarginConstraint])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [unowned self] in
            self.startLabel.text = "Move around to find a plane"
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) { [unowned self] in
            self.startLabel.isHidden = true
            self.BackgroundView.isHidden = true
        }
        
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc private func tapped(gesture: UITapGestureRecognizer) {
        
        let touchPosition = gesture.location(in: sceneView)
        
        switch(self.trackStatus) {
            case .notAdded:
        
                let hitResults = sceneView.hitTest(touchPosition, types: .existingPlane)
        
                if !hitResults.isEmpty {
            
                    guard let hitResult = hitResults.first else {
                        return
                    }
//                    addTrack(hitResult: hitResult)
                    addCar1(hitResult: hitResult)
                    addCar2(hitResult: hitResult)
            }
            self.trackStatus = .added
            case .added:
                
                let hitResults = sceneView.hitTest(touchPosition, options: nil)
                
                if !hitResults.isEmpty {
                    guard let hitResult = hitResults.first else {
                        return
                    }
                    let TrackNode = hitResult.node
                    
                    let force = SCNVector3(1,0,0)
                    TrackNode.physicsBody?.applyForce(force, asImpulse: true)
            }
        }
    }
    
//    private func addTrack(hitResult: ARHitTestResult) {
//
////        let yOffset = 0.3
//
//        if let TrackNode = nodeForScene(sceneName: "art.scnassets/physics.scn", nodeName: "Track") {
//
//            let size = TrackNode.boundingBox.max
//
//            // create track geometry
//            let TrackGeometry = SCNBox(width: CGFloat(size.x), height: CGFloat(size.y/2), length: CGFloat(size.z),chamferRadius: 0)
//
//            // create a physics shape
//            let TrackShape = SCNPhysicsShape(geometry: TrackGeometry, options: nil)
//
//            // adding physics body
//            TrackNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: TrackShape)
//            TrackNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y,hitResult.worldTransform.columns.3.z)
//            sceneView.scene.rootNode.addChildNode(TrackNode)
//        }
//    }
    
    private func addCar1(hitResult: ARHitTestResult) {

        let xOffset = 0.5
        let yOffset = -0.3

        if let Car1Node = nodeForScene(sceneName: "art.scnassets/physics.scn", nodeName: "Car_001") {

            let size = Car1Node.boundingBox.max

            let Car1Geometry = SCNBox(width: CGFloat(size.x), height: CGFloat(size.y/2), length: CGFloat(size.z),chamferRadius: 0)

            let Car1Shape = SCNPhysicsShape(geometry: Car1Geometry, options: nil)

            Car1Node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: Car1Shape)
            Car1Node.physicsBody?.categoryBitMask = BodyType.car1.rawValue
            Car1Node.position = SCNVector3(hitResult.worldTransform.columns.3.x+Float(xOffset),hitResult.worldTransform.columns.3.y,hitResult.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(Car1Node)
        }
    }
    private func addCar2(hitResult: ARHitTestResult) {

//        let xOffset = 0.3

        if let Car2Node = nodeForScene(sceneName: "art.scnassets/physics.scn", nodeName: "Car_002") {

            let size = Car2Node.boundingBox.max

            // create track geometry
            let Car2Geometry = SCNBox(width: CGFloat(size.x), height: CGFloat(size.y/2), length: CGFloat(size.z),chamferRadius: 0)

            // create a physics shape
            let Car2Shape = SCNPhysicsShape(geometry: Car2Geometry, options: nil)

            // adding physics body
            Car2Node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: Car2Shape)
            Car2Node.name = "car2"
            Car2Node.physicsBody?.categoryBitMask = BodyType.car2.rawValue
            Car2Node.physicsBody?.contactTestBitMask = BodyType.car1.rawValue
            Car2Node.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y,hitResult.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(Car2Node)
        }
    }
    
    public func nodeForScene(sceneName :String,nodeName :String) -> SCNNode? {

            let scene = SCNScene(named: sceneName)!
            return scene.rootNode.childNode(withName: nodeName,recursively: true)

    }
    
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("didBegin")
        var contactNode :SCNNode!
        var lastContactNode: SCNNode!
        
        if contact.nodeA.name == "car1" {
            contactNode = contact.nodeA
            } else {
            contactNode = contact.nodeB
            }

        if lastContactNode != nil && lastContactNode == contactNode {
                return
            
        }
        lastContactNode = contactNode
        let force = SCNVector3(0,0,0)
        contactNode.physicsBody?.applyForce(force, asImpulse: true)
    }


    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        self.startLabel.isHidden = false
        self.BackgroundView.isHidden = false
        
        self.startLabel.text = "Plane Detected"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.startLabel.text = "Tap once to place the experiment!"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.startLabel.isHidden = true
            self.BackgroundView.isHidden = true
        }


        if !(anchor is ARPlaneAnchor) {
            return
        }

        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
        
    }

    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first
        
        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
}

