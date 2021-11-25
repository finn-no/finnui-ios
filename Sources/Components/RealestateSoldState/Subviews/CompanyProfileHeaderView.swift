import UIKit
import FinniversKit

class CompanyProfileHeaderView: UIView {

    // MARK: - Private properties

    private lazy var remoteImageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
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
        addSubview(remoteImageView)

        NSLayoutConstraint.activate([
            remoteImageView.heightAnchor.constraint(equalToConstant: 76),
            remoteImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            remoteImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            remoteImageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: .spacingM),
            remoteImageView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -.spacingM),
            remoteImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Internal methods

    func configure(backgroundColor: UIColor, imageUrl: String, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        self.backgroundColor = backgroundColor
        remoteImageView.dataSource = remoteImageViewDataSource
        remoteImageView.loadImage(for: imageUrl, imageWidth: .zero)
    }
}
