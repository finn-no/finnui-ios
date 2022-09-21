import UIKit
import FinniversKit

class CompanyProfileLogoView: UIView {

    // MARK: - Private properties

    private let logoHeight: CGFloat
    private let verticalSpacing: CGFloat

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    init(logoHeight: CGFloat = 40, verticalSpacing: CGFloat = .spacingS, withAutoLayout: Bool) {
        self.logoHeight = logoHeight
        self.verticalSpacing = verticalSpacing
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: logoHeight),

            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: verticalSpacing),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalSpacing)
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
        logoImageView.loadImage(for: imageUrl, imageWidth: .zero)
    }
}
