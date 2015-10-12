//
//  FaceView.swift
//  Joyful
//
//  Created by Yohannes Wijaya on 10/12/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    // MARK: - Stored Properties
    
    var lineWidth: CGFloat = 3 {
        didSet { self.setNeedsDisplay() }
    }
    var color = UIColor.blueColor() {
        didSet { self.setNeedsDisplay() }
    }
    var scale: CGFloat = 0.90 {
        didSet { self.setNeedsDisplay() }
    }
    
    // MARK: - Computed Properties
    
    var faceCenter: CGPoint {
        return self.convertPoint(self.center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return min(self.bounds.size.width, self.bounds.size.height) / 2 * self.scale
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        facePath.lineWidth = self.lineWidth
        self.color.set() // equivalent to self.color.setFill(); self.color.setStroke()
        facePath.stroke()
    }
}
