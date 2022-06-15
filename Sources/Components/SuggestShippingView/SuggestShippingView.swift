import Combine
import FinniversKit

public final class SuggestShippingView: UIView {
    private var viewModel: SuggestShippingViewModel
    private var cancellables = Set<AnyCancellable>()
    private var buttonCancellable: AnyCancellable?

    private let imageHorizontalInset: CGFloat = .spacingS

    private let horizontalContainer: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.alignment = .center
        return stackView
    }()

    private let containerView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = .spacingM
        return stackView
    }()

    private let textContainer: UIStackView = UIStackView(axis: .vertical)

    private lazy var title: Label = {
        let label = Label(style: .captionStrong)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var message: Label = {
        let label = Label(style: .caption)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var suggestShippingbutton: Button = {
        let button = Button(style: .suggestShippingStyle)
        button.contentEdgeInsets = UIEdgeInsets(
            top: .spacingS + .spacingXS,
            leading: .spacingXL,
            bottom: .spacingS + .spacingXS,
            trailing: .spacingXL + imageHorizontalInset
        )
        button.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            leading: imageHorizontalInset,
            bottom: 0,
            trailing: -imageHorizontalInset
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        var shippingTruck = UIImage(named: .shippingTruck)
        button.tintColor = .textAction
        button.setImage(shippingTruck, for: .normal)
        return button
    }()

    private lazy var showInfoButton = Button(style: .flat)
    private lazy var loadingIndicator = LoadingIndicatorView(withAutoLayout: true)

    public init(viewModel: SuggestShippingViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.sardine.cgColor
        layer.cornerRadius = 3

        addSubview(horizontalContainer)
        horizontalContainer.fillInSuperview(margin: .spacingM)
        textContainer.addArrangedSubviews([
            title,
            message
        ])
        containerView.addArrangedSubviews([
            textContainer,
            suggestShippingbutton
        ])
        horizontalContainer.addArrangedSubview(containerView)

        NSLayoutConstraint.activate([
            loadingIndicator.heightAnchor.constraint(equalToConstant: 30),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 30),
        ])

        viewModel
            .$state
            .sink { [weak self] newState in
                self?.applyState(newState)
            }
            .store(in: &cancellables)
    }

    @objc
    private func didTapButton() {
        viewModel.suggestShipping()
    }

    private func applyState(_ newState: SuggestShippingViewModel.State) {
        switch newState {
        case .suggestShipping:
            title.text = viewModel.title
            message.text = viewModel.message
            suggestShippingbutton.setTitle(viewModel.buttonTitle, for: .normal)
            buttonCancellable = suggestShippingbutton
                .publisher(for: .touchUpInside)
                .sink { [weak self] _ in
                    self?.viewModel.suggestShipping()
                }

        case .processing:
            containerView.alpha = 0
            addSubview(loadingIndicator)
            loadingIndicator.centerInSuperview()
            loadingIndicator.startAnimating()
            layoutIfNeeded()
        }
    }
}

private extension Button.Style {
    static var suggestShippingStyle: Button.Style {
        .flat.overrideStyle(
            bodyColor: .dynamicColor(defaultColor: .bgPrimary, darkModeColor: .bgTertiary),
            borderWidth: 2,
            borderColor: .dynamicColor(defaultColor: .sardine, darkModeColor: .sardine),
            highlightedBodyColor: .dynamicColor(defaultColor: .bgPrimary, darkModeColor: .bgTertiary),
            highlightedBorderColor: .dynamicColor(defaultColor: .sardine, darkModeColor: .sardine)
        )
    }
}
