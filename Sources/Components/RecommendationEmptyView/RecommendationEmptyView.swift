import FinniversKit
import UIKit

public class RecommendationEmptyView: UIView {

    private lazy var iconImageView: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)

        let topSpacer = UILayoutGuide()
        let bottomSpacer = UILayoutGuide()
        addLayoutGuide(topSpacer)
        addLayoutGuide(bottomSpacer)

        iconImageView.setContentCompressionResistancePriority(.defaultHigh - 1, for: .vertical)

        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            iconImageView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .spacingXL),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),

            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalTo: topSpacer.heightAnchor),
        ])
    }

    public func configure(_ model: RecommendationEmptyViewModel) {
        titleLabel.text = model.titleText
        detailLabel.text = model.detailText

        if let icon = model.icon {
            iconImageView.image = icon
        } else {
            iconImageView.image = UIImage(named: .repair)
        }
    }

}
