////
////  RocketViewController.swift
////  WWDC19
////
////  Created by Aaron Cheung 430 on 16/3/2019.
////  Copyright © 2019 Aaron Cheung 430. All rights reserved.
////
import UIKit
import PlaygroundSupport
import ARKit
import SceneKit
import AVFoundation

public class RocketViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    public var sceneView: ARSCNView!
        
    public var planes = [OverlayPlane]()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var BackgroundView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private var rocket :Rocket!
    
    var player: AVAudioPlayer?
    
    public override func loadView() {
        
        sceneView = ARSCNView()
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        sceneView.session.delegate = self
//        sceneView.debugOptions = [ ARSCNDebugOptions.showFeaturePoints ]
        
        self.view = sceneView
        
        registerGestureRecognizers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
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
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func registerGestureRecognizers() {

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(tapGestureRecognizer)

        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        sceneView.addGestureRecognizer(doubleTapGestureRecognizer)
    }

    @objc private func tapped(gesture: UITapGestureRecognizer) {
        
        self.startLabel.isHidden = false
        self.BackgroundView.isHidden = false
        
        self.startLabel.text = "Tap twice to launch!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.startLabel.isHidden = true
            self.BackgroundView.isHidden = true
        }
        
        let touchPosition = gesture.location(in: sceneView)

        let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlane)

        guard let hitTest = hitTestResults.first else {
            return
        }

        addRocket(hitTest)
    }
    
    public func addRocket(_ hitTest: ARHitTestResult) {

        let rocketScene = SCNScene(named: "art.scnassets/rocket.scn")

        let rocket = Rocket(scene: rocketScene!)
        rocket.name = "Rocket"
        rocket.position = SCNVector3(hitTest.worldTransform.columns.3.x, hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)

        sceneView.scene.rootNode.addChildNode(rocket)
    }
    
    public func nodeForScene(sceneName :String,nodeName :String) -> SCNNode? {
        
        let scene = SCNScene(named: sceneName)!
        return scene.rootNode.childNode(withName: nodeName,recursively: true)
        
    }
    
    @objc private func doubleTapped(recognizer: UITapGestureRecognizer) {

        guard let rocketNode = self.sceneView.scene.rootNode.childNode(withName: "Rocket", recursively: true)
            else {
                fatalError("Rocket not found")
        }
        
        guard let smokeNode = rocketNode.childNode(withName: "smokeNode", recursively: true)
            else {
                fatalError("SmokeNode not found")
        }

        smokeNode.removeAllParticleSystems()

        let fire = SCNParticleSystem(named: "art.scnassets/fire.scnp", inDirectory: nil)

        smokeNode.addParticleSystem(fire!)

        rocketNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        rocketNode.physicsBody?.isAffectedByGravity = false
        rocketNode.physicsBody?.damping = 0.0

        rocketNode.physicsBody?.applyForce(SCNVector3(0,50,0), asImpulse: false)
        
        playSound()
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "RocketSound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        self.startLabel.isHidden = false
        self.BackgroundView.isHidden = false
        
        self.startLabel.text = "Plane Detected"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.startLabel.text = "Tap once to place the rocket!"
        }

    }

}
