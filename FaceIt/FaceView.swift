//
//  FaceView.swift
//  FaceIt
//
//  Created by Roder on 2017/3/29.
//  Copyright © 2017年 Roder. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    public var lineWidth:CGFloat = 5.0 {didSet{setNeedsDisplay()}}
    
    @IBInspectable
    public var skullColor:UIColor = UIColor.blue{didSet{setNeedsDisplay()}}
    
    @IBInspectable
    public var smileCurvature: CGFloat = 0.0{didSet{setNeedsDisplay()}}

    @IBInspectable
    public var eyeBrowDegree: CGFloat = 0.0{didSet{setNeedsDisplay()}}
    
    @IBInspectable
    public var eyeOpen = true{didSet{setNeedsDisplay()}}

    public var scale = CGFloat(1.0){didSet{setNeedsDisplay()}}
    
    private var skullCenter: CGPoint{
        return CGPoint(x:CGFloat(bounds.width/2), y:CGFloat(bounds.height/2))
    }
    
    private var skullRadius : CGFloat{
        return min(bounds.width, bounds.height) / 2 * scale
    }
    
    public enum FaceExpression{
        case Normal
        case Angry
        case Happy
    }
    
    
    private struct Ratios {
        static let SkullRaduisToEyeBrowOffset: CGFloat = 4
        static let SkullRaduisToEyeOffset: CGFloat = 3
        static let SkullRaduisToEyeRadius: CGFloat = 10
        static let SkullRaduisToMouthWidth: CGFloat = 1
        static let SkullRaduisToMouthHeight: CGFloat = 3
        static let SkullRaduisToMouthOffset: CGFloat = 3
        
        static let SkullRaduisToEyeBrowWidth: CGFloat = 3
        static let SkullRaduisToEyeBrowHeight: CGFloat = 8
        static let EyeToEyeBrowOffset: CGFloat = 3

    }
    
    private enum Eye{
        case Left
        case Right
    }
    
    public func changeScale(uiGestureReconizer: UIPinchGestureRecognizer){
        print("changeScale ")
        switch uiGestureReconizer.state{
        case .ended, .changed:
                scale *= uiGestureReconizer.scale
                uiGestureReconizer.scale = 1.0
        default:
            break
        }
    }
    
    private func getEyeCenter(eye:Eye) -> CGPoint{
        let eyeOffset = skullRadius / Ratios.SkullRaduisToEyeOffset
        var eyeCenter = skullCenter
        
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    private func pathForSkull() -> UIBezierPath{
        let skullPath = getPath(withCenter: skullCenter, withRadius:skullRadius)
        skullColor.set()
        return skullPath;
    }
    
    private func pathForEye(eye:Eye) -> UIBezierPath{
        let eyeRadius = skullRadius / Ratios.SkullRaduisToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)

        var path : UIBezierPath
        if eyeOpen {
            
            path = getPath(withCenter: eyeCenter, withRadius:eyeRadius)
        }else{
            path = UIBezierPath()
            path.lineWidth = lineWidth
            
            let start = CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y)
            let end = CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y)
            
            path.move(to: start)
            path.addLine(to: end)
        }
        skullColor.set()
        return path;
    }
    
    private func pathForMouth() -> UIBezierPath{
        let mouthWidth = skullRadius / Ratios.SkullRaduisToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRaduisToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRaduisToMouthOffset
        
        let rect = CGRect(x: skullCenter.x - (mouthWidth / 2), y:skullCenter.y + mouthOffset, width:mouthWidth, height: mouthHeight)
        
        let start = CGPoint(x:rect.minX, y:rect.minY)
        let end = CGPoint(x:rect.maxX, y:rect.minY)
        
        let smileOffset = CGFloat(max(-1, min(smileCurvature, 1))) *  rect.height
        
        let cp1 = CGPoint(x:rect.minX + rect.width/3, y:rect.minY + smileOffset)
        let cp2 = CGPoint(x:rect.maxX - rect.width/3, y:rect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path;
    }
    
    private func pathForEyeBrow(eye : Eye) -> UIBezierPath{
        let eyeBrowWidth = skullRadius / Ratios.SkullRaduisToEyeBrowWidth
        let eyeBrowHeight = skullRadius / Ratios.SkullRaduisToEyeBrowHeight
        let eyeBrowOffset = skullRadius / Ratios.EyeToEyeBrowOffset
        
        let eyeCenter = getEyeCenter(eye: eye)
        
        let rect = CGRect(x: eyeCenter.x - (eyeBrowWidth / 2), y : eyeCenter.y - eyeBrowOffset, width:eyeBrowWidth, height: eyeBrowHeight)
        
        let eyeBrowCurveOffset = CGFloat(max(-1, min(eyeBrowDegree, 1))) *  rect.height
        
        var start = CGPoint(x:rect.midX, y:rect.midY)
        var end = CGPoint(x:rect.midX, y:rect.midY)
        
        switch eye {
        case .Left:
            start = CGPoint(x:rect.minX, y:rect.midY)
            end = CGPoint(x:rect.maxX, y: rect.midY + eyeBrowCurveOffset)
        case .Right:
            start = CGPoint(x:rect.minX, y: rect.midY + eyeBrowCurveOffset)
            end = CGPoint(x:rect.maxX, y:rect.midY)
        }
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = lineWidth
        
        return path;
    }
    
    
    private func getPath(withCenter givenCenter : CGPoint, withRadius givenRadius : CGFloat) -> UIBezierPath{
        let path = UIBezierPath(arcCenter: givenCenter, radius: givenRadius, startAngle: CGFloat(0.0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        
        pathForSkull().stroke()
        pathForEye(eye:.Left).stroke()
        pathForEye(eye:.Right).stroke()
        pathForMouth().stroke()
        pathForEyeBrow(eye:.Left).stroke()
        pathForEyeBrow(eye:.Right).stroke()
    }
 

}
