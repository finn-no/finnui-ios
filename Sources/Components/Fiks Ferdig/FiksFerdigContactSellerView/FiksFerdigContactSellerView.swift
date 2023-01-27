import FinniversKit
import Combine

public final class FiksFerdigContactSellerView: UIView {

    // MARK: - Private properties

    private let viewModel: FiksFerdigContactSellerViewModel
    private var cancellable: AnyCancellable?

    private let messageLabel: Label = {
        let label = Label(style: .caption)
        label.numberOfLines = 0
        return label
    }()

    private let containerView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = .spacingXS
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(
            top: .spacingM,
            leading: .spacingM,
            bottom: .spacingXS,
            trailing: .spacingM
        )
        return stackView
    }()

    private let contactSellerButton: Button = {
        let button = Button(style: .flat)
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(named: .fiksFerdigContactSeller), for: .normal)
        button.titleEdgeInsets = .init(
            top: 0,
            left: .spacingS / 2,
            bottom: 0,
            right: -.spacingS / 2
        )
        button.contentEdgeInsets = .init(
            top: 0,
            left: .spacingS / 2,
            bottom: 0,
            right: .spacingS / 2
        )
        button.imageEdgeInsets = .init(
            top: 0,
            left: -.spacingS / 2,
            bottom: 0,
            right: .spacingS / 2
        )
        return button
    }()

    // MARK: - Init

    public init(viewModel: FiksFerdigContactSellerViewModel, withAutoLayout: Bool) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
        decorate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        layer.borderWidth = 1
        layer.cornerRadius = 3

        addSubview(containerView)
        containerView.fillInSuperview()

        containerView.addArrangedSubviews([
            messageLabel,
            contactSellerButton
        ])

        cancellable = contactSellerButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.viewModel.contactSeller()
            })
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.borderDefault.cgColor
    }

    // MARK: - Private methods

    private func decorate() {
        messageLabel.text = viewModel.message
        contactSellerButton.setTitle(viewModel.buttonTitle, for: .normal)
    }
}
