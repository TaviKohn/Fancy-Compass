//
//  ViewController.swift
//  Fancy Compass
//
//  Created by Tavi Kohn on 7/24/15.
//  Copyright (c) 2015 Tavi Kohn. All rights reserved.
//

import UIKit
import SceneKit
import CoreMotion

class ViewController: UIViewController {
	
	let motionManager = CMMotionManager()
	var scene : SCNScene!
	lazy var compass = SCNNode()
	var compassData = CompassData()
	
	@IBOutlet var sceneView: SCNView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		let motionManager = CMMotionManager()
		
		scene = SCNScene(named: "Fancy Compass.scnassets/Compass.dae")!	//Load Scene from Compass.dae
		
		//Set up the Camera
		
		let cameraNode = SCNNode()
		
		cameraNode.camera = SCNCamera()
		scene.rootNode.addChildNode(cameraNode)
		
		cameraNode.position = SCNVector3(x: 0, y:0, z: 4)
		
		//Set up the light sources
		
		let lightNodeTop = SCNNode()
		lightNodeTop.light = SCNLight()
		lightNodeTop.light!.type = SCNLightTypeOmni
		lightNodeTop.position = SCNVector3(x: 0, y: 0, z: 5)
		scene.rootNode.addChildNode(lightNodeTop)
		
		let lightNodeBottom = SCNNode()
		lightNodeBottom.light = SCNLight()
		lightNodeBottom.light!.type = SCNLightTypeOmni
		lightNodeBottom.position = SCNVector3(x: 0, y: 0, z: -5)
		scene.rootNode.addChildNode(lightNodeBottom)
		
		let ambientLightNode = SCNNode()
		ambientLightNode.light = SCNLight()
		ambientLightNode.light!.type = SCNLightTypeAmbient
		ambientLightNode.light!.color = UIColor.whiteColor()
		scene.rootNode.addChildNode(ambientLightNode)
		
		//Set up the 3D Compass
		
		compass = scene.rootNode.childNodeWithName("Compass", recursively: true)!
		compass.position = SCNVector3(x: 0, y: 0, z: 0)
		self.compassData.updateCompassOrientation(compass)
		
		let sceneView = self.view as! SCNView
		sceneView.scene = scene
		
		sceneView.allowsCameraControl = true
		
		sceneView.showsStatistics = true
	}
	
	override func viewDidAppear(animated: Bool) {
		/*
		if motionManager.accelerometerAvailable {
			motionManager.accelerometerUpdateInterval = 0.1
			motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { [weak self] (data: CMAccelerometerData!, error: NSError!) in
					self.xRotation = atan(data.acceleration.x / sqrt((data.acceleration.y ^ 2) + (data.acceleration.z ^ 2)))
					self.yRotation = atan(data.acceleration.y / sqrt((data.acceleration.x ^ 2) + (data.acceleration.z ^ 2)))
			}
			)
		}
		*/
		
		//if motionManager.deviceMotionAvailable {
			motionManager.deviceMotionUpdateInterval = 0.1
			motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {deviceManager, error in
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
					self.compassData.updateCompassOrientation(self.compass)
					self.compassData.xRotation = self.motionManager.deviceMotion.attitude.pitch
					self.compassData.yRotation = self.motionManager.deviceMotion.attitude.roll
				}
				})
		//} else {
		//	println("Motion Data Not Available!")
		//}
		
		/*
		if motionManager.deviceMotionAvailable {
			motionManager.deviceMotionUpdateInterval = 0.1
			motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {deviceManager, error in
				self.xRotation = motion.attitude.pitch
			})
		}
		*/
	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

