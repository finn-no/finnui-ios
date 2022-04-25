import UIKit
import FinniversKit

class ExtendedProfileHeaderView: UIView {

    // MARK: - Private properties

    private let viewModel: ExtendedProfileViewModel
    private let showExpandButton: Bool
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        return stackView
    }()

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
        if let slogan = viewModel.slogan, !slogan.isEmpty {
            topLabel.text = slogan
            if !showExpandButton {
                bottomLabel.text = viewModel.companyName
                bottomLabel.isHidden = false
            }
        } else {
            topLabel.text = viewModel.companyName
        }

        textStackView.addArrangedSubviews([topLabel, bottomLabel])
        contentStackView.addArrangedSubviews([textStackView, expandToggleImageView])
        addSubview(contentStackView)
        contentStackView.fillInSuperview(margin: .spacingM)

        NSLayoutConstraint.activate([
            expandToggleImageView.widthAnchor.constraint(equalToConstant: .spacingM),
            expandToggleImageView.heightAnchor.constraint(equalToConstant: .spacingM),
        ])
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
