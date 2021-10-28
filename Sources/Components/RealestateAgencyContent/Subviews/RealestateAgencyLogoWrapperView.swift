import UIKit
import FinniversKit

class RealestateAgencyLogoWrapperView: UIView {

    // MARK: - Private properties

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
        logoImageView.fillInSuperview(margin: .spacingM)

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 48)
        ])
    }

    // MARK: - Internal methods

    func configure(
        with viewModel: RealestateAgencyContentViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        backgroundColor = viewModel.colors.logoBackground

        logoImageView.dataSource = remoteImageViewDataSource
        logoImageView.loadImage(for: viewModel.logoUrl, imageWidth: .zero)
    }
}
