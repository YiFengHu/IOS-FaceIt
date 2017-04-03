//
//  FaceExpression.swift
//  FaceIt
//
//  Created by Roder on 2017/3/30.
//  Copyright © 2017年 Roder. All rights reserved.
//

import Foundation

public struct FaceExpression{
    var eye = Eye.Open
    var eyeBrow = EyeBrow.Normal
    var mouth = Mouth.Neutral
    
    public enum Eye : Int{
        case Close
        case Open
    }
    
    public enum EyeBrow : Int{
        case Relax
        case Normal
        case Angry
        
        func moreRelaxBrow() -> EyeBrow{
            return EyeBrow(rawValue : rawValue - 1) ?? .Relax
        }
        
        func moreAngryBrow() -> EyeBrow{
            return EyeBrow(rawValue : rawValue + 1) ?? .Angry
        }
    }
    
    public enum Mouth : Int{
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func happierMouth() -> Mouth{
            return Mouth(rawValue : rawValue - 1) ?? .Smile
        }
        
        func sadderMouth() -> Mouth{
            return Mouth(rawValue : rawValue + 1) ?? .Frown
        }
    }

}
