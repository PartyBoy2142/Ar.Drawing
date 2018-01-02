//
//  ViewController.swift
//  Ar.Drawing
//
//  Created by Sam Sabah on 30.12.17.
//  Copyright © 2017 Sam Sabah. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var restartOutlit: UIButton!
    
    
    var showHiddenRestart = false
    var mainNode = SCNNode()
    var currentColor = UIColor.black
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.scene.rootNode.addChildNode(mainNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        //  get the location of the Camera
        drawButton.backgroundColor = currentColor
        guard let cameraPoint = sceneView.pointOfView else {
            
            return
        }
        let cameraTransform = cameraPoint.transform
        let cameralocation = SCNVector3(x:cameraTransform.m41, y:cameraTransform.m42, z:cameraTransform.m43)
        let cameraOrientation = SCNVector3(x: -cameraTransform.m31,y: -cameraTransform.m32, z: -cameraTransform.m33)
        
        // Position = x1+x2,y1+y2, z1+z2 = the reall World Position!
        let cameraPosition = SCNVector3Make(cameralocation.x + cameraOrientation.x, cameralocation.y + cameraOrientation.y, cameralocation.z + cameraOrientation.z)
        DispatchQueue.main.async {
            if self.drawButton.isTouchInside {
                let sphere = SCNSphere(radius: 0.02)
                let material = SCNMaterial()
                material.diffuse.contents = self.currentColor
                sphere.materials = [material]
                
                if self.showHiddenRestart == false{
                    self.showButt()
                    
                }
                
                let sphereNode = SCNNode(geometry: sphere)
                sphereNode.position = SCNVector3(x: cameraPosition.x, y:cameraPosition.y, z: cameraPosition.z)
                self.mainNode.addChildNode(sphereNode)
                
            }
        }

   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    func showButt()  {
        showHiddenRestart = true
        restartOutlit.isHidden = false
    }
    
    
    
    
    @IBAction func restartButt(_ sender: UIButton) {
        self.mainNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
    }
    
}
