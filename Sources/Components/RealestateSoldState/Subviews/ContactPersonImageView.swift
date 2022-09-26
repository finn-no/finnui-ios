import UIKit
import FinniversKit

class ContactPersonImageView: UIView {

    // MARK: - Internal properties

    var dataSource: RemoteImageViewDataSource? {
        get { remoteImageView.dataSource }
        set { remoteImageView.dataSource = newValue }
    }

    // MARK: - Private properties

    private lazy var remoteImageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFill
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        clipsToBounds = true
        addSubview(remoteImageView)

        NSLayoutConstraint.activate([
            remoteImageView.topAnchor.constraint(equalTo: topAnchor),
            remoteImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            remoteImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            remoteImageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor)
        ])
    }

    // MARK: - Internal methods

    func loadImage(for imagePath: String, imageWidth: CGFloat) {
        remoteImageView.loadImage(
            for: imagePath,
            imageWidth: imageWidth,
            modify: {
                $0?.resizeToFillSquareContainer(sideLength: imageWidth)
            }
        )
    }
}

// MARK: - Private extensions

private extension UIImage {
    /// This method will resize the image to fill the container.
    /// The image will be drawn so it's top and centered.
    func resizeToFillSquareContainer(sideLength: CGFloat) -> UIImage {
        let aspect = size.width / size.height
        let imageRect: CGRect

        if sideLength / aspect > sideLength {
            let height = sideLength / aspect
            imageRect = CGRect(
                x: 0,
                y: (sideLength - height) / 2,
                width: sideLength,
                height: height
            )
        } else {
            let width = sideLength * aspect
            imageRect = CGRect(
                x: (sideLength - width) / 2,
                y: 0,
                width: width,
                height: sideLength
            )
        }

        return UIGraphicsImageRenderer(bounds: imageRect).image { _ in
            draw(in: imageRect)
        }
    }
}
