//
//  ViewController.swift
//  AR Business Card
//
//  Created by Fabiola Saga on 3/22/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var swiftNode: SCNNode?
    var gitHubNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        let swiftScene = SCNScene(named: "art.scnassets/swiftLogo.scn")
        let gitHubScene = SCNScene(named: "art.scnassets/Octocat.scn")
        swiftNode = swiftScene?.rootNode
        gitHubNode = gitHubScene?.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARImageTrackingConfiguration()
        
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Buisiness Cards", bundle: Bundle.main) {
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 2
        }

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.0)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
         
            var shapeNode: SCNNode?
            
            switch imageAnchor.referenceImage.name {
                
            case CardType.businessCard.rawValue :
                shapeNode = swiftNode
            case CardType.businessCardBack.rawValue:
                shapeNode = gitHubNode
            default:
                break
            }
            
//            if imageAnchor.referenceImage.name == "businessCard" {
//                shapeNode = swiftNode
//            } else {
//                shapeNode = gitHubNode
//            }
            
            guard let shape = shapeNode else { return nil}
            node.addChildNode(shape)
            
        }
      return node
    }


}

enum CardType: String {
    
    case businessCard = "businessCard"
    case businessCardBack = "businessCardBack"
    
}
