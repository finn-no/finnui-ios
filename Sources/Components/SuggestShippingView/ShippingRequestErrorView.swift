import Combine
import FinniversKit

public final class ShippingRequestErrorView: UIView {
    private var viewModel: ShippingRequestErrorViewModel
    private var cancellables = Set<AnyCancellable>()
    private let containerView = UIStackView(axis: .vertical)

    private lazy var titleLabel: Label = {
        let label = Label(style: .captionStrong)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .caption)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var readMoreButton = Button(style: .flat)

    public init(viewModel: ShippingRequestErrorViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
        decorateWithViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.sardine.cgColor
        layer.cornerRadius = 3

        addSubview(containerView)
        let insets = UIEdgeInsets(
            top: .spacingM,
            leading: .spacingM,
            bottom: -.spacingXS,
            trailing: -.spacingM
        )
        containerView.fillInSuperview(insets: insets)
        containerView.addArrangedSubviews([
            titleLabel,
            messageLabel
        ])
        containerView.setCustomSpacing(.spacingXS, after: messageLabel)
        containerView.addArrangedSubview(readMoreButton)
    }

    private func decorateWithViewModel() {
        titleLabel.text = viewModel.title
        messageLabel.text = viewModel.message
        readMoreButton.setTitle(viewModel.buttonTitle, for: .normal)
        readMoreButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.openInfoURL()
            }
            .store(in: &cancellables)
    }
}
