import UIKit
import FinniversKit

class RealestateAgencyLogoWrapperView: UIView {

    // MARK: - Private properties

    private let imageHeight: CGFloat = 32
    private lazy var logoImageHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: imageHeight)
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
        with viewModel: RealestateAgencyContentViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        backgroundColor = viewModel.colors.logoBackground

        logoImageView.dataSource = remoteImageViewDataSource
        logoImageView.loadImage(for: viewModel.logoUrl, imageWidth: .zero, modify: { [weak self] image in
            if let self = self, let image = image {
                let heightWidthRatio = image.size.width / image.size.height
                self.logoImageWidthConstraint.constant = self.imageHeight * heightWidthRatio
            }

            return image
        })
    }
}
