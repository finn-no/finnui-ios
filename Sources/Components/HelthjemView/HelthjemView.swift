import FinniversKit

public protocol HelthjemViewDelegate: AnyObject {
    func helthjemViewDidSelectPrimaryButton(_ view: HelthjemView)
    func helthjemViewDidSelectSecondaryButton(_ view: HelthjemView)
}

public final class HelthjemView: UIView {
    public weak var delegate: HelthjemViewDelegate?

    // MARK: - Subviews

    private lazy var helthjemImage: UIImage = {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return .init(named: .shipWithHelthjemDarkmode)
        default:
            return .init(named: .shipWithHelthjem)
        }
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: helthjemImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var textContainerView: UIStackView = {
        let textContainerView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textContainerView.translatesAutoresizingMaskIntoConstraints = false
        textContainerView.spacing = .spacingS
        textContainerView.axis = .vertical
        return textContainerView
    }()

    private lazy var primaryButton: Button = {
        let buttonStyle = Button.Style.flat.overrideStyle(
            bodyColor: .primaryButtonBackgroundColor,
            borderWidth: 2,
            borderColor: .primaryButtonBorderColor,
            highlightedBodyColor: .primaryButtonBackgroundColor,
            highlightedBorderColor: .primaryButtonBorderColor
        )
        let button = Button(style: buttonStyle)
        button.backgroundColor = .primaryButtonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var secondaryButton: Button = {
        let buttonStyle = Button.Style.flat.overrideStyle(
            borderWidth: 0.0,
            borderColor: nil,
            textColor: .secondaryButtonColor,
            highlightedBorderColor: nil,
            highlightedTextColor: .secondaryButtonColor
        )
        let button = Button(style: buttonStyle)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSecondaryButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var buttonContainerView: UIStackView = {
        let buttonContainerView = UIStackView(arrangedSubviews: [primaryButton, secondaryButton])
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.spacing = .spacingS
        return buttonContainerView
    }()

    private var buttonContainerViewTrailingAnchor = NSLayoutConstraint()
    private lazy var isIpad = isHorizontalSizeClassRegular

    // MARK: - Init

    public init() {
        super.init(frame: .zero)
        isAccessibilityElement = true
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch traitCollection.userInterfaceStyle {
        case .dark:
            helthjemImage = .init(named: .shipWithHelthjemDarkmode)
        default:
            helthjemImage = .init(named: .shipWithHelthjem)
        }

        imageView.image = helthjemImage
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .backgroundColor
        layer.cornerRadius = 8

        var imageViewVerticalConstraint = NSLayoutConstraint()
        if isIpad {
            primaryButton.size = .small
            secondaryButton.size = .small
            imageViewVerticalConstraint = imageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        } else {
            buttonContainerView.axis = .vertical
            imageViewVerticalConstraint = imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM)
        }

        addSubview(imageView)
        addSubview(textContainerView)
        addSubview(buttonContainerView)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 96),
            imageView.widthAnchor.constraint(equalToConstant: 96),
            imageViewVerticalConstraint,
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingL),

            textContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingXL),
            textContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),

            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -.spacingL),
            detailLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -.spacingL),

            buttonContainerView.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            buttonContainerView.topAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: .spacingL),

            bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: .spacingM)
        ])
    }

    // MARK: - Actions

    @objc private func handlePrimaryButtonTap() {
        delegate?.helthjemViewDidSelectPrimaryButton(self)
    }

    @objc private func handleSecondaryButtonTap() {
        delegate?.helthjemViewDidSelectSecondaryButton(self)
    }

    // MARK: - Public

    public func configure(_ viewModel: HelthjemViewModel) {
        accessibilityLabel = viewModel.accessibilityLabel

        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail

        primaryButton.accessibilityLabel = viewModel.primaryButtonAccessibilityLabel
        primaryButton.setTitle(viewModel.primaryButtonTitle, for: .normal)

        buttonContainerViewTrailingAnchor.isActive = false

        if let secondaryButtonTitle = viewModel.secondaryButtonTitle,
            !secondaryButtonTitle.isEmpty {
            secondaryButton.isHidden = false
            secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
            primaryButton.accessibilityLabel = viewModel.secondaryButtonAccessibilityLabel
        } else {
            secondaryButton.isHidden = true
        }

        let trailingAnchor = viewModel.secondaryButtonTitle != nil ? secondaryButton.trailingAnchor : primaryButton.trailingAnchor

        if isIpad {
            buttonContainerViewTrailingAnchor = buttonContainerView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            )
        } else {
            buttonContainerViewTrailingAnchor = buttonContainerView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM
            )
        }

        buttonContainerViewTrailingAnchor.isActive = true
    }
}

// MARK: - Styling

private extension UIColor {
    class var backgroundColor: UIColor {
        dynamicColorIfAvailable(defaultColor: .init(hex: "#F1F9FF"), darkModeColor: .darkIce)
    }

    class var primaryButtonBackgroundColor: UIColor {
        dynamicColorIfAvailable(defaultColor: .bgPrimary, darkModeColor: .bgTertiary)
    }

    class var primaryButtonBorderColor: UIColor {
        dynamicColorIfAvailable(defaultColor: .init(hex: "#C3CCD9"), darkModeColor: .textSecondary)
    }

    class var secondaryButtonColor: UIColor {
        dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: .milk)
    }
}