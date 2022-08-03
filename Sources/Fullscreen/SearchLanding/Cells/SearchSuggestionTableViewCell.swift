import UIKit
import FinniversKit

class SearchSuggestionTableViewCell: UITableViewCell {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .horizontal)
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

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary
        setDefaultSelectedBackgound()

        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(iconImageView)

        let layoutGuide = UILayoutGuide()
        contentView.addLayoutGuide(layoutGuide)

        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            layoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            layoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            layoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingS),

            iconImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingS),
            titleLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .spacingXS),
            detailLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Configure

    func configure(with item: SearchSuggestionGroupItem) {
        titleLabel.attributedText = item.title
        detailLabel.text = item.detail
    }
}
