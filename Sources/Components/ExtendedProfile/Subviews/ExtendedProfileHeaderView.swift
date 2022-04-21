import UIKit
import FinniversKit

class ExtendedProfileHeaderView: UIView {

    // MARK: - Private properties

    private let viewModel: ExtendedProfileViewModel
    private let showExpandButton: Bool
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var topLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = viewModel.style.textColor
        return label
    }()

    private lazy var bottomLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = viewModel.style.textColor
        label.isHidden = true
        return label
    }()

    private lazy var expandToggleImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = viewModel.style.textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    init(viewModel: ExtendedProfileViewModel, showExpandButton: Bool, withAutoLayout: Bool) {
        self.viewModel = viewModel
        self.showExpandButton = showExpandButton
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        if let slogan = viewModel.slogan {
            topLabel.text = slogan
            if !showExpandButton {
                bottomLabel.text = viewModel.companyName
                bottomLabel.isHidden = false
            }
        } else {
            topLabel.text = viewModel.companyName
        }

        textStackView.addArrangedSubviews([topLabel, bottomLabel])
        addSubview(textStackView)

        if showExpandButton {
            addSubview(expandToggleImageView)

            NSLayoutConstraint.activate([
                textStackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
                textStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
                textStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),

                expandToggleImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: .spacingM),
                expandToggleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                expandToggleImageView.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: .spacingM),
                expandToggleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
                expandToggleImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingM),
                expandToggleImageView.widthAnchor.constraint(equalToConstant: .spacingM),
                expandToggleImageView.heightAnchor.constraint(equalToConstant: .spacingM),
            ])
        } else {
            textStackView.fillInSuperview(margin: .spacingM)
        }
    }

    // MARK: - Internal methods

    func configure(isExpanded: Bool) {
        if isExpanded {
            expandToggleImageView.image = UIImage(named: .chevronUp)
        } else {
            expandToggleImageView.image = UIImage(named: .chevronDown)
        }
    }
}
