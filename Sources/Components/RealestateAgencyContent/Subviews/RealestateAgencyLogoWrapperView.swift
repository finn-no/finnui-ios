import UIKit
import FinniversKit

class RealestateAgencyLogoWrapperView: UIView {

    // MARK: - Private properties

    private lazy var logoImageHeight: CGFloat = traitCollection.logoImageHeight
    private lazy var logoImageHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: logoImageHeight)
    private lazy var logoImageWidthConstraint = logoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 150)

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageHeightConstraint,
            logoImageWidthConstraint,

            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Internal methods

    func configure(
        imageUrl: String,
        backgroundColor: UIColor,
        remoteImageViewDataSource: RemoteImageViewDataSource?
    ) {
        self.backgroundColor = backgroundColor

        logoImageView.dataSource = remoteImageViewDataSource
        logoImageView.loadImage(for: imageUrl, imageWidth: .zero, modify: { [weak self] image in
            if let self = self, let image = image {
                let heightWidthRatio = image.size.width / image.size.height
                self.logoImageWidthConstraint.constant = self.logoImageHeight * heightWidthRatio
            }

            return image
        })
    }
}

// MARK: - Private extensions

private extension UITraitCollection {
    var logoImageHeight: CGFloat {
        switch horizontalSizeClass {
        case .regular:
            return 32
        default:
            return 24
        }
    }
}
