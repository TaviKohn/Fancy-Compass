//
//  compassData.swift
//  Fancy Compass
//
//  Created by Tavi Kohn on 7/28/15.
//  Copyright (c) 2015 Tavi Kohn. All rights reserved.
//

import Foundation
import SceneKit
import CoreMotion

public class CompassData {
	public var xRotation : Double = M_PI_2
	public var yRotation : Double = 0
	public var zRotation : Double = 0
	
	let motionManager = CMMotionManager()
	
	var direction : Double = 0
	
	init() {
		
	}
	
	public func updateCompassOrientation(compass: SCNNode) -> SCNNode {
		compass.eulerAngles = SCNVector3(x: Float(xRotation), y: Float(yRotation), z: Float(zRotation))
		print("eulerAngles Vector:\tx: \(xRotation)\ty: \(yRotation)\tz: \(zRotation)", appendNewline: false)
		return compass
	}
	
}