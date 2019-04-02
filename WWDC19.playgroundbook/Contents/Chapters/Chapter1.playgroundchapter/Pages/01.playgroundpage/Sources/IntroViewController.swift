//
//  IntroViewController.swift
//  WWDC19
//
//  Created by Aaron Cheung 430 on 15/3/2019.
//  Copyright © 2019 Aaron Cheung 430. All rights reserved.
//

import UIKit
import SceneKit
import PlaygroundSupport

public class IntroViewController: UIViewController {
    
    public var sceneView: SCNView = SCNView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = sceneView
        
        let scene = SCNScene(named: "art.scnassets/car.scn")!
        
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true

    }
    
}
