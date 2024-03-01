import FinniversKit
import UIKit

public protocol RecommendationConsentViewDelegate: AnyObject {
    func recommendationConsentViewDidTapAllowButton(_ view: RecommendationConsentView)
}

public class RecommendationConsentView: UIView {

    public weak var delegate: RecommendationConsentViewDelegate?

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

    private lazy var allowButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleAllowButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(allowButton)

        let topSpacer = UILayoutGuide()
        let bottomSpacer = UILayoutGuide()
        addLayoutGuide(topSpacer)
        addLayoutGuide(bottomSpacer)

        iconImageView.setContentCompressionResistancePriority(.defaultHigh - 1, for: .vertical)
        let imageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 250)
        imageViewHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            iconImageView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageViewHeightConstraint,

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .spacingXL),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            allowButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .spacingM),
            allowButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            allowButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            allowButton.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),

            bottomSpacer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalTo: topSpacer.heightAnchor),
        ])
    }

    public func configure(_ model: RecommendationConsentViewModel) {
        titleLabel.text = model.titleText
        detailLabel.text = model.detailText
        allowButton.setTitle(model.buttonText, for: .normal)

        if let icon = model.icon {
            iconImageView.image = icon
        } else {
            iconImageView.image = UIImage(named: .lock)
        }
    }

    @objc private func handleAllowButtonTapped(_ sender: UIButton) {
        delegate?.recommendationConsentViewDidTapAllowButton(self)
    }

}

