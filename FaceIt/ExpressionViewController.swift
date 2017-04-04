//
//  ExpressionViewController.swift
//  FaceIt
//
//  Created by Roder on 2017/4/4.
//  Copyright © 2017年 Roder. All rights reserved.
//

import UIKit

class ExpressionViewController : UIViewController{

    private let segueDictionary : Dictionary<String, FaceExpression> = [
        "happiness" : FaceExpression(eye:.Open, eyeBrow:.Relax, mouth:.Smile),
        "exciting" : FaceExpression(eye:.Open, eyeBrow:.Relax, mouth:.Neutral),
        "sad" : FaceExpression(eye:.Open, eyeBrow:.Relax, mouth:.Frown),
        "anry" : FaceExpression(eye:.Open, eyeBrow:.Normal, mouth:.Frown),
        "mad" : FaceExpression(eye:.Open, eyeBrow:.Angry, mouth:.Frown)
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let targetSegue = segue.destination as? ViewController{
            if let identifier = segue.identifier{
                if let expression  = segueDictionary[identifier]{
                    targetSegue.faceExpression = expression
                    if let sendingButton = sender as? UIButton{
                        targetSegue.navigationItem.title = sendingButton.currentTitle
                    }
                }

            }
        }
    }
}
