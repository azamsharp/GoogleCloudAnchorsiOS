//
//  ViewController.swift
//  DragRacing
//
//  Created by Mohammad Azam on 5/16/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import ARCore

class ViewController: UIViewController, ARSCNViewDelegate, GARSessionDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private var gSession :GARSession!
    private var arAnchor :ARAnchor!
    private var garAnchor :GARAnchor!
    private var rootRef :DatabaseReference!
    private var cloudIdentifier :String!
    
    private var isPlaneAdded :Bool = false
    
    private var hud :MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootRef = Database.database().reference()
        self.sceneView.autoenablesDefaultLighting = true
        
        // enable the arcore session
        self.gSession = try! GARSession(apiKey: "InsertYourKeyHere", bundleIdentifier: nil)
        
        // Set the view's delegate
        sceneView.delegate = self
        self.gSession.delegate = self
        self.gSession.delegateQueue = DispatchQueue.main
        
        sceneView.session.delegate = self
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        
        registerGestureRecognizers()
        setupUI()
        clearAllAnchors()
        setupObservers()
    }
    
    private func clearAllAnchors() {
        
        self.rootRef.child("cloud-anchors").removeValue()
    }
    
    private func setupUI() {
        
        let addBlockButton = UIButton(type: .roundedRect)
        addBlockButton.translatesAutoresizingMaskIntoConstraints = false
        addBlockButton.backgroundColor = UIColor(fromHexString: "#2ecc71")
        addBlockButton.tintColor = UIColor.white
        addBlockButton.setTitle("Add Block", for: .normal)
        addBlockButton.addTarget(self, action: #selector(addBlock), for: .touchUpInside)
        
        self.sceneView.addSubview(addBlockButton)
        
        addBlockButton.leadingAnchor.constraint(equalTo: self.sceneView.leadingAnchor, constant: 40).isActive = true
        addBlockButton.bottomAnchor.constraint(equalTo: self.sceneView.bottomAnchor, constant: -20).isActive = true
        addBlockButton.widthAnchor.constraint(equalToConstant: 100)
        addBlockButton.heightAnchor.constraint(equalToConstant: 44)
        addBlockButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        addBlockButton.layer.cornerRadius = 10.0
        
        // resolve cloud anchors button
        let resolveAnchorButton = UIButton(type: .roundedRect)
        resolveAnchorButton.translatesAutoresizingMaskIntoConstraints = false
        resolveAnchorButton.backgroundColor = UIColor.red
        resolveAnchorButton.tintColor = UIColor.white
        resolveAnchorButton.setTitle("Resolve", for: .normal)
        resolveAnchorButton.addTarget(self, action: #selector(resolveAnchor), for: .touchUpInside)
        
        self.sceneView.addSubview(resolveAnchorButton)
        
        resolveAnchorButton.trailingAnchor.constraint(equalTo: self.sceneView.trailingAnchor, constant: -40).isActive = true
        resolveAnchorButton.bottomAnchor.constraint(equalTo: self.sceneView.bottomAnchor, constant: -20).isActive = true
        resolveAnchorButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        resolveAnchorButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        resolveAnchorButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        resolveAnchorButton.layer.cornerRadius = 10.0
    }
    
    private func setupObservers() {
      
        self.rootRef.child("cloud-anchors").observe(.value) { (snapshot) in
         
            if let dictionary = snapshot.value as? [String:Any] {
                
                self.cloudIdentifier = dictionary["cloudIdentifier"] as! String
                let hex = dictionary["hex"] as! String
                
                if let cloudAnchor = try? self.gSession.resolveCloudAnchor(withIdentifier: self.cloudIdentifier) {
                    
                    let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor(fromHexString: hex)
                    box.materials = [material]
                    
                    let node = SCNNode(geometry: box)
                    node.position = SCNVector3(cloudAnchor.transform.columns.3.x, cloudAnchor.transform.columns.3.y, cloudAnchor.transform.columns.3.z)
                    self.sceneView.scene.rootNode.addChildNode(node)
                    
                }
            }
            
        }
    }
    
    @objc func resolveAnchor() {
        
        self.rootRef.child("cloud-anchors").observeSingleEvent(of: .value) { (snapshot) in
            
            let dictionary = snapshot.value as! [String:Any]
            self.cloudIdentifier = dictionary["cloudIdentifier"] as! String
            let hex = dictionary["hex"] as! String
            
            if let cloudAnchor = try? self.gSession.resolveCloudAnchor(withIdentifier: self.cloudIdentifier) {
                
                let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor(fromHexString: hex)
                box.materials = [material]
                
                let node = SCNNode(geometry: box)
                node.position = SCNVector3(cloudAnchor.transform.columns.3.x, cloudAnchor.transform.columns.3.y, cloudAnchor.transform.columns.3.z)
                self.sceneView.scene.rootNode.addChildNode(node)
                
            }
        }
    }
    
    @objc func addBlock() {
        
        let grAnchor = try? self.gSession.resolveCloudAnchor(withIdentifier: self.cloudIdentifier)
        
        if let cloudAnchor = grAnchor {
            
            let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            let node = SCNNode(geometry: box)
            node.position = SCNVector3(cloudAnchor.transform.columns.3.x, cloudAnchor.transform.columns.3.y, cloudAnchor.transform.columns.3.z)
            self.sceneView.scene.rootNode.addChildNode(node)
            
            let cloudAnchorRef = self.rootRef.child("cloud-anchors")
            cloudAnchorRef.setValue(["cloudIdentifier":self.cloudIdentifier,"hex":"#FFFFFF"])
            
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        try! self.gSession.update(frame)
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addAnchorWithTransform(transform :matrix_float4x4) {
        
        self.arAnchor = ARAnchor(transform: transform)
        self.sceneView.session.add(anchor: self.arAnchor)
        
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud.label.text = "Hosting Anchor..."
                
        // host the anchor
        self.garAnchor = try! self.gSession.hostCloudAnchor(self.arAnchor)
    }
    
    func session(_ session: GARSession, didHostAnchor anchor: GARAnchor) {
        
        if let cloudIdentifier = anchor.cloudIdentifier {
            self.cloudIdentifier = cloudIdentifier
            
            DispatchQueue.main.async {
                self.hud.label.text = "Cloud Anchor Hosted Successfully!"
                self.hud.hide(animated: true, afterDelay: 2.0)
            }
        }
    }
    
    func session(_ session: GARSession, didFailToHostAnchor anchor: GARAnchor) {
        
        DispatchQueue.main.async {
            self.hud.label.text = "Error Hosting Cloud Anchor!"
            self.hud.hide(animated: true, afterDelay: 2.0)
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            print("PLANE FOUND...")
        }
    }
    
    private func hitTestWithPlane(touch :CGPoint) {
        
        let hitTestResults = sceneView.hitTest(touch, types: .existingPlane)
        if !hitTestResults.isEmpty {
            
            if let hitTestResult = hitTestResults.first {
                
                print("plane hit test")
                print(hitTestResult.worldTransform)
                addAnchorWithTransform(transform: hitTestResult.worldTransform)
            }
        }
    }
    
    private func hitTestWithVirtualObject(touch :CGPoint, view :SCNView) {
        
        let hitTestResults = view.hitTest(touch, options: nil)
        if !hitTestResults.isEmpty {
            if let hitTestResult = hitTestResults.first {
                
                let node = hitTestResult.node
                let material = SCNMaterial()
                let randomColor = UIColor.random()
                
                material.diffuse.contents = randomColor
                node.geometry?.materials = [material]
                
                // save it in firebase
                let cloudAnchorRef = self.rootRef.child("cloud-anchors")
            cloudAnchorRef.setValue(["cloudIdentifier":self.cloudIdentifier,"hex":randomColor.hexString()])
            }
        }
        
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        if !self.isPlaneAdded && self.cloudIdentifier == nil {
            
            if let view = recognizer.view as? ARSCNView {
                hitTestWithPlane(touch: recognizer.location(in: view))
            }
            
            self.isPlaneAdded = true
            
        } else if let view = recognizer.view as? SCNView {
            hitTestWithVirtualObject(touch :recognizer.location(in: view), view: view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
