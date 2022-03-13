//
//  ViewController.swift
//  FaceView
//
//  Created by 林家富 on 2022/3/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            updateUI()
        }
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .frown) {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateUI() {
        switch expression.eyes {
            case .open:
                faceView?.eyesOpen = true
            case .closed:
                faceView?.eyesOpen = false
            case .squinting:
                faceView?.eyesOpen = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures = [
        FacialExpression.Mouth.grin : 0.5,
        FacialExpression.Mouth.frown: -1.0,
        FacialExpression.Mouth.smile: 1.0,
        FacialExpression.Mouth.smirk: 0.0,
        FacialExpression.Mouth.neutral: -0.5,
    ]
}
