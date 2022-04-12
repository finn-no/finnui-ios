import UIKit
import FinniversKit

class ExtendedProfileHeaderView: UIView {

    // MARK: - Private properties

    private let viewModel: ExtendedProfileViewModel
    private let showExpandButton: Bool

    private lazy var sloganLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = viewModel.style.textColor
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
        sloganLabel.text = viewModel.slogan ?? viewModel.companyName

        addSubview(sloganLabel)

        if showExpandButton {
            addSubview(expandToggleImageView)

            NSLayoutConstraint.activate([
                sloganLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
                sloganLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
                sloganLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),

                expandToggleImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
                expandToggleImageView.leadingAnchor.constraint(equalTo: sloganLabel.trailingAnchor, constant: .spacingM),
                expandToggleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
                expandToggleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),
            ])
        } else {
            sloganLabel.fillInSuperview(margin: .spacingM)
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
