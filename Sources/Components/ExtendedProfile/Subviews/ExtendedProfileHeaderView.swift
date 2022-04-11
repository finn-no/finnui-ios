import UIKit
import FinniversKit

class ExtendedProfileHeaderView: UIView {

    // MARK: - Private properties

    private let viewModel: ExtendedProfileViewModel

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

    init(viewModel: ExtendedProfileViewModel, withAutoLayout: Bool) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        sloganLabel.text = viewModel.slogan ?? viewModel.companyName

        addSubview(sloganLabel)
        addSubview(expandToggleImageView)

        NSLayoutConstraint.activate([
            sloganLabel.topAnchor.constraint(equalTo: topAnchor),
            sloganLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sloganLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            expandToggleImageView.topAnchor.constraint(equalTo: topAnchor),
            expandToggleImageView.leadingAnchor.constraint(equalTo: sloganLabel.trailingAnchor, constant: .spacingM),
            expandToggleImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            expandToggleImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
