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
    
    let Smiliness = 0.85
    
    // MARK: - Computed Properties
    
    var faceCenter: CGPoint {
        return self.convertPoint(self.center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return min(self.bounds.size.width, self.bounds.size.height) / 2 * self.scale
    }
    
    // MARK: - Constants
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    // MARK: - Enums
    
    private enum Eye {
        case Left, Right
    }
    
    // MARK: - Methods Override
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        facePath.lineWidth = self.lineWidth
        self.color.set() // equivalent to self.color.setFill(); self.color.setStroke()
        facePath.stroke()
        
        self.bezierPathForEye(.Left).stroke()
        self.bezierPathForEye(.Right).stroke()
        
        self.bezierPathForSmile(self.Smiliness).stroke()
    }
    
    // MARK: - Local Methods
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = self.faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = self.faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = self.faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = self.faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let bezierPath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        bezierPath.lineWidth = self.lineWidth
        return bezierPath
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath {
        let mouthWidth = self.faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = self.faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = self.faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPointMake(self.faceCenter.x - mouthWidth / 2, self.faceCenter.y + mouthVerticalOffset)
        let end = CGPointMake(start.x + mouthWidth, start.y)
        let cp1 = CGPointMake(start.x + mouthWidth / 3, start.y + smileHeight)
        let cp2 = CGPointMake(end.x - mouthWidth / 3, cp1.y)
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(start)
        bezierPath.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        bezierPath.lineWidth = lineWidth
        return bezierPath
    }
}
