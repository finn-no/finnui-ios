//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class GradientView: UIView {
    enum Axis {
        case vertical
        case horizontal
    }

    private let gradient = CAGradientLayer()
    private let startColor: UIColor
    private let endColor: UIColor

    // MARK: - Init

    init(startColor: UIColor, endColor: UIColor, axis: Axis = .vertical) {
        self.startColor = startColor
        self.endColor = endColor

        gradient.colors = [startColor.cgColor, endColor.cgColor]

        switch axis {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            break
        }

        super.init(frame: .zero)
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }

    override func draw(_ rect: CGRect) {
        gradient.frame = self.bounds

        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
}
