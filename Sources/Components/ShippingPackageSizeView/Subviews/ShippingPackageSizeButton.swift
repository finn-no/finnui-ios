import UIKit
import FinniversKit

class ShippingPackageSizeButton: UIView {

    // MARK: - Internal properties

    let viewModel: ShippingPackageSizeItemModel

    var isSelected: Bool = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    // MARK: - Private properties

    private var contentStackViewConstraints = [NSLayoutConstraint]()
    private lazy var contentStackView = UIStackView(withAutoLayout: true)
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXXS, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.tintColor = .textPrimary
        return imageView
    }()

    // MARK: - Init

    init(viewModel: ShippingPackageSizeItemModel, withAutoLayout: Bool) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()

        isSelected = viewModel.isInitiallySelected
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 4

        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.body

        textStackView.addArrangedSubviews([titleLabel, bodyLabel])
        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 31),
            imageView.widthAnchor.constraint(equalToConstant: 31)
        ])

        configurePresentation()
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderWidth = isSelected ? 2 : 1
        layer.borderColor = isSelected ? .primaryBlue : .btnDisabled
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            configurePresentation()
        }
    }

    // MARK: - Private methods

    private func configurePresentation() {
        contentStackView.removeArrangedSubviews()

        let stackViewMargin: CGFloat

        switch traitCollection.horizontalSizeClass {
        case .regular:
            stackViewMargin = .spacingL
            contentStackView.addArrangedSubviews([textStackView, imageView])
            contentStackView.axis = .horizontal
            contentStackView.spacing = .spacingM
            contentStackView.distribution = .equalSpacing
            contentStackView.alignment = .center

            titleLabel.textAlignment = .natural
            bodyLabel.textAlignment = .natural
        default:
            stackViewMargin = .spacingM
            contentStackView.addArrangedSubviews([imageView, textStackView])
            contentStackView.axis = .vertical
            contentStackView.spacing = .spacingM
            contentStackView.distribution = .equalSpacing
            contentStackView.alignment = .center

            titleLabel.textAlignment = .center
            bodyLabel.textAlignment = .center
        }

        NSLayoutConstraint.deactivate(contentStackViewConstraints)
        contentStackViewConstraints = [
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: stackViewMargin),
            contentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: stackViewMargin),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -stackViewMargin),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -stackViewMargin),
        ]
        NSLayoutConstraint.activate(contentStackViewConstraints)

        layoutIfNeeded()
    }
}

