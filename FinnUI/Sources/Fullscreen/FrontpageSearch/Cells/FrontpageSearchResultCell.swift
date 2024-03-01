import UIKit
import FinniversKit

final class FrontpageSearchResultCell: UICollectionViewCell {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .textPrimary
        label.font = .detail
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .searchSmall)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.tintColor = .textPrimary
        return imageView
    }()

    // MARK: - Init

    init(
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(iconImageView)

        let layoutGuide = UILayoutGuide()
        addLayoutGuide(layoutGuide)

        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: topAnchor),
            layoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            layoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            layoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),

            iconImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingS),
            titleLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .spacingXS),
            detailLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Configure

    func configure(with item: FrontpageSearchGroupItem) {
        titleLabel.attributedText = item.title
        titleLabel.textColor = item.titleColor
        detailLabel.text = item.detail
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        titleLabel.attributedText = nil
        titleLabel.textColor = .textPrimary
        detailLabel.text = nil
    }
}

