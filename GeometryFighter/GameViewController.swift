//
//  GameViewController.swift
//  GeometryFighter,
//
//  Created by Vincenzo Pugliese on 12/05/2018.
//  Copyright © 2018 Vincenzo Pugliese. All rights reserved.
//
//from the Ray Wenderlich book: “3D Apple Games by Tutorials”



import UIKit
import SceneKit


class GameViewController: UIViewController {
    
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    
    var cameraNode: SCNNode!
    
    var spawnTime: TimeInterval = 0
    
    var game = GameHelper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setupScene()
        setupCamera()
//        spawnShape()
    
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
        
        scnView.delegate = self
        scnView.isPlaying = true //otherwise it enters in pause
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"

    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
   func spawnShape() {
        // 1
        var geometry:SCNGeometry
        // 2
        switch ShapeType.random() {
           
        case .sphere:
            geometry = SCNSphere(radius: 2.0)
            
        case .cylinder:
            
            geometry = SCNCylinder(radius: 1.2, height: 2)
            
        case .cone:
            
            geometry = SCNCone(topRadius: 0.5, bottomRadius: 1, height: 1.5)
            
        case .tube:
            
             geometry = SCNTube(innerRadius: 0.3, outerRadius: 0.5, height: 1.1)
            
        default:
            // 3
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0,
                              chamferRadius: 0.0)
        }
    
    

    
    geometry.materials.first?.diffuse.contents = UIColor.cyan
        // 4
        let geometryNode = SCNNode(geometry: geometry)
    
    geometryNode.physicsBody =
        SCNPhysicsBody(type: .dynamic, shape: nil)
    
        // 5
        scnScene.rootNode.addChildNode(geometryNode)
    //apply random force vector to the shape:
    
    // 1
    let randomX = Float.random(min: -2, max: 2)
    let randomY = Float.random(min: 10, max: 18)
     

    

    // 2
    let force = SCNVector3(x: Float(randomX), y: Float(randomY) , z: 0)
    // 3
    let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
    // 4
    geometryNode.physicsBody?.applyForce(force,
        at: position, asImpulse: true)
    
    let color = UIColorExtensions.random()
    geometry.materials.first?.diffuse.contents = color
    
    let trailEmitter = createTrail(color: color, geometry: geometry)
    geometryNode.addParticleSystem(trailEmitter)
    
    }
    
    // 1
    func createTrail(color: UIColor, geometry: SCNGeometry) ->
        SCNParticleSystem {
            // 2
            let trail = SCNParticleSystem(named: "Trail.scnp", inDirectory: nil)!
            // 3
            trail.particleColor = color
            // 4
            trail.emitterShape = geometry
            // 5
            return trail
    }
    
    func cleanScene() {
        // 1
        for node in scnScene.rootNode.childNodes {
            // 2
            if node.presentation.position.y < -2 {
                // 3
                node.removeFromParentNode()
            }
        }
    }

    
    
}

   extension GameViewController: SCNSceneRendererDelegate {
        // 2
        func renderer(_ renderer: SCNSceneRenderer,
                      updateAtTime time: TimeInterval) {
            // 3
            if time > spawnTime {
                spawnShape()

                // 2
                spawnTime = time + TimeInterval(Float.random(min: 0.2, max: 1.5))
                
            }
            cleanScene()
        }
    }

