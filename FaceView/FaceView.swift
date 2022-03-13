//
//  FaceView.swift
//  FaceView
//
//  Created by 林家富 on 2022/3/12.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.9 {
        didSet {
            setNeedsDisplay()
        }
    }
   
    @IBInspectable
    var eyesOpen: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var mouthCurvature: Double = -0.5  { // 1.0 is full smile -1.0 is full frown
        didSet {
            setNeedsDisplay()
        }
    }

    
    @IBInspectable
    var lineWidth: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var color: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @objc func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
            case .changed, .ended:
                scale *= pinchRecognizer.scale
                print(scale)
                pinchRecognizer.scale = 1
            default:
                break
        }
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath? {
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset // move the Y more upper
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset // move X right or left
            return eyeCenter
        }
        
        let eyeRaius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        
        var path: UIBezierPath?
        if eyesOpen {
            path = UIBezierPath(
                arcCenter: eyeCenter,
                radius: eyeRaius,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: false
            )
        } else {
            path = UIBezierPath()
            path?.move(to: CGPoint(x: eyeCenter.x - eyeRaius, y: eyeCenter.y))
            path?.addLine(to: CGPoint(x: eyeCenter.x + eyeRaius, y: eyeCenter.y))
        }
        
        path?.lineWidth = self.lineWidth
        
        return path
    }
    
    private func pathForSkull() -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: skullCenter,
            radius: skullRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: false
        )
        
        path.lineWidth = 5
        
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = max(-1, min(mouthCurvature, 1)) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
        self.color.set()
        pathForSkull().stroke()
        pathForEye(Eye.left)?.stroke()
        pathForEye(Eye.right)?.stroke()
        pathForMouth().stroke()
    }

}
