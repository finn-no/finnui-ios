import UIKit
import FinniversKit

class RealtorInfoView: UIView {

    // MARK: - Private properties

    private lazy var realtorLogoImageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var realtorNameLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = .textSecondary
        return label
    }()

    // MARK: - Init

    init(
        realtorName: String?,
        realtorLogoUrl: String?,
        remoteImageViewDataSource: RemoteImageViewDataSource?
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup(
            realtorName: realtorName,
            realtorLogoUrl: realtorLogoUrl,
            remoteImageViewDataSource: remoteImageViewDataSource
        )
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(
        realtorName: String?,
        realtorLogoUrl: String?,
        remoteImageViewDataSource: RemoteImageViewDataSource?
    ) {
        realtorNameLabel.text = realtorName
        realtorLogoImageView.dataSource = remoteImageViewDataSource

        if let realtorLogoUrl = realtorLogoUrl {
            realtorLogoImageView.loadImage(for: realtorLogoUrl, imageWidth: .zero)
        }

        addSubview(realtorLogoImageView)
        addSubview(realtorNameLabel)

        NSLayoutConstraint.activate([
            realtorLogoImageView.topAnchor.constraint(equalTo: topAnchor),
            realtorLogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            realtorLogoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            realtorLogoImageView.widthAnchor.constraint(equalToConstant: 48),

            realtorNameLabel.topAnchor.constraint(equalTo: topAnchor),
            realtorNameLabel.leadingAnchor.constraint(equalTo: realtorLogoImageView.trailingAnchor, constant: .spacingS),
            realtorNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            realtorNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
