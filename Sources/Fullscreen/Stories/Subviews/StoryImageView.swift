import Foundation
import UIKit

class StoryImageView: UIImageView {
    private var gradientFrameSize: CGSize?

    // MARK: - Internal methods

    func configure(withImage image: UIImage?) {
        guard let image = image else {
            self.image = nil
            return
        }
        self.image = image
        contentMode = image.isLandscapeOrientation ? .scaleAspectFit : .scaleAspectFill

        if image.isLandscapeOrientation {
            backgroundColor = image.averageColor
        }
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()

        if frame.size != .zero,
           gradientFrameSize == nil || gradientFrameSize != frame.size {
            gradientFrameSize = frame.size
            addGradients()
        }
    }

    // MARK: - Private methods

    private func addGradients() {
        addTopGradient()
        addBottomGradient()
    }

    private func addTopGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.opacity = 0.5
        gradientLayer.colors = [UIColor.darkSardine.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: 250)
        layer.addSublayer(gradientLayer)
    }

    private func addBottomGradient() {
        let gradientLayer = CAGradientLayer()
        let radius: CGFloat = 250
        gradientLayer.opacity = 0.75
        gradientLayer.colors = [UIColor.darkIce.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = CGRect(x: 0.0, y: frame.height - radius, width: frame.width, height: radius)
        layer.addSublayer(gradientLayer)
    }
}

// MARK: - Private extensions

private extension UIImage {
    var isLandscapeOrientation: Bool {
        return size.width >= size.height
    }

    var averageColor: UIColor? {
        // https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
        guard
            let inputImage = CIImage(image: self),
            let workingColorSpace = kCFNull
        else { return nil }

        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
