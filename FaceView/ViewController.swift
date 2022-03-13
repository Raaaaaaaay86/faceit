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
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(
                target: faceView,
                action: handler
            )
            faceView.addGestureRecognizer(pinchRecognizer)
            
            let tapRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(self.toggleEyes(byReactingTo:))
            )
            tapRecognizer.numberOfTapsRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            
            let swipeUpRecoginzer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(self.increaseHappiness)
            )
            swipeUpRecoginzer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecoginzer)
            
            let swipDownRecoginzer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(self.decreaseHappiness)
            )
            swipDownRecoginzer.direction = .down
            faceView.addGestureRecognizer(swipDownRecoginzer)
            
            updateUI()
        }
    }
    
    @objc func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = expression.eyes == .closed ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    @objc func increaseHappiness() {
        expression = expression.happier
    }
    
    @objc func decreaseHappiness() {
        expression = expression.sadder
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
