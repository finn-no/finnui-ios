import UIKit
import FinniversKit

class ExtendedProfileLogoView: UIView {

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

        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 40),

            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS)
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
