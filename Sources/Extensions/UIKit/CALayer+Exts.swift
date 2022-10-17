import UIKit

public extension CALayer {
    func addCircle(at position: CGPoint, radius: CGFloat, color: UIColor) -> CAShapeLayer {
        let circlePath = UIBezierPath(
            arcCenter: position,
            radius: radius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color.cgColor
        addSublayer(shapeLayer)
        return shapeLayer
    }
}
