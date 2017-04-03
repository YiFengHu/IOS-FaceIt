//
//  ViewController.swift
//  FaceIt
//
//  Created by Roder on 2017/3/29.
//  Copyright © 2017年 Roder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var faceExpression = FaceExpression(eye: .Open, eyeBrow: .Relax, mouth: .Frown){didSet{updateUI()}}
    
    var currentRotation = CGFloat(0.0)
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            
            faceView.addGestureRecognizer( UIPinchGestureRecognizer(
                    target:faceView, action: #selector(FaceView.changeScale))
            )
            
            let upSwipeReconizer = UISwipeGestureRecognizer(
                target:self, action: #selector( ViewController.changeSmile)
            )
            upSwipeReconizer.direction = .up
            faceView.addGestureRecognizer(upSwipeReconizer)
            
            let downSwipeReconizer = UISwipeGestureRecognizer(
                target:self, action: #selector( ViewController.changeSmile)
            )
            downSwipeReconizer.direction = .down
            faceView.addGestureRecognizer(downSwipeReconizer)

            updateUI()
        }
    }
    
    @IBAction func onFaceViewTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended{
           switch faceExpression.eye {
           case .Open: faceExpression.eye = .Close
           case .Close: faceExpression.eye = .Open
           }
        }
    }
    
    
    @IBAction func onRotate(_ sender: UIRotationGestureRecognizer) {
        print("rotate: \(sender.rotation)")
        switch sender.state {
        case .ended, .changed:
            
            let deltaRotation = sender.rotation - currentRotation
            let expectDelta = CGFloat(M_PI) / CGFloat(4)
            let shouldUpdate = abs(deltaRotation) > expectDelta
            
            print("deltaRotation: \(deltaRotation), expectDelta:\(expectDelta), shouldUpdate:\(shouldUpdate)")

            
            if shouldUpdate {
                if deltaRotation > 0{
                    faceExpression.eyeBrow = faceExpression.eyeBrow.moreRelaxBrow()
                }else{
                    faceExpression.eyeBrow = faceExpression.eyeBrow.moreAngryBrow()
                }
                
                currentRotation = sender.rotation
            }
        default:
            break
        }
    }
    
    public func changeScale(uiGestureReconizer: UIPinchGestureRecognizer){
        
        switch uiGestureReconizer.state{
        case .ended, .changed:
            faceView.changeScale(uiGestureReconizer: uiGestureReconizer)
        default:
            break
        }
    }
    
    public func changeSmile(gestureReconizer:UISwipeGestureRecognizer){
        print("changeSmile")

        switch gestureReconizer.state {
            case .ended:
            if gestureReconizer.direction == .up{
                faceExpression.mouth = faceExpression.mouth.happierMouth()
            }else if gestureReconizer.direction == .down{
                faceExpression.mouth = faceExpression.mouth.sadderMouth()
            }
        default:
            break
        }
    }
    
    private func updateUI()  {
        switch faceExpression.eyeBrow {
        case .Angry:faceView.eyeBrowDegree = 1.0
        case .Normal:faceView.eyeBrowDegree = 0.0
        case .Relax:faceView.eyeBrowDegree = -1.0
        }
        
        switch faceExpression.eye {
        case .Open:faceView.eyeOpen = true
        case .Close:faceView.eyeOpen = false
        }

        switch faceExpression.mouth {
        case .Smile: faceView.smileCurvature = 1.0
        case .Grin: faceView.smileCurvature = 0.5
        case .Neutral: faceView.smileCurvature = 0.0
        case .Smirk: faceView.smileCurvature = -0.5
        case .Frown: faceView.smileCurvature = -1.0
        }
        
    }
}


