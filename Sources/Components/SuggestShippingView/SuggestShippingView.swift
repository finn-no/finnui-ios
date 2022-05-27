import Combine
import FinniversKit

public final class SuggestShippingView: UIView {
    private var viewModel: SuggestShippingViewModel!
    private var cancellables = Set<AnyCancellable>()

    private let imageHorizontalInset: CGFloat = .spacingS

    private let horizontalContainer: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.alignment = .center
        return stackView
    }()

    private let containerView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 24
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

    private lazy var button: Button = {
        let button = Button(style: .flat.overrideStyle(
            bodyColor: .primaryButtonBackgroundColor,
            borderWidth: 2,
            borderColor: .primaryButtonBorderColor,
            highlightedBodyColor: .primaryButtonBackgroundColor,
            highlightedBorderColor: .primaryButtonBorderColor
        ))
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
        button.setImage(UIImage(named: .shippingTruck), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    private lazy var loadingIndicator = LoadingIndicatorView(withAutoLayout: true)

    private func setup() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.sardine.cgColor
        layer.cornerRadius = 3

        addSubview(horizontalContainer)
        horizontalContainer.fillInSuperview(margin: 16)
        textContainer.addArrangedSubviews([
            title,
            message
        ])
        containerView.addArrangedSubviews([
            textContainer,
            button
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
        case .suggestShipping(let suggestShippingViewModel):
            title.text = suggestShippingViewModel.title
            message.text = suggestShippingViewModel.message
            button.setTitle(suggestShippingViewModel.buttonTitle, for: .normal)

        case .processing:
            containerView.alpha = 0
            addSubview(loadingIndicator)
            loadingIndicator.centerInSuperview()
            loadingIndicator.startAnimating()
            layoutIfNeeded()

        case .error(let errorViewModel):
            loadingIndicator.removeFromSuperview()
            containerView.alpha = 1
            title.text = errorViewModel.title
            message.text = errorViewModel.message
            button.removeFromSuperview()
        }
    }

    public static func create(with viewModel: SuggestShippingViewModel) -> SuggestShippingView {
        let view = SuggestShippingView(withAutoLayout: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.viewModel = viewModel
        view.setup()
        return view
    }
}

private extension UIColor {
    class var primaryButtonBackgroundColor: UIColor {
        dynamicColor(defaultColor: .bgPrimary, darkModeColor: .bgTertiary)
    }

    class var primaryButtonBorderColor: UIColor {
        dynamicColor(defaultColor: .sardine, darkModeColor: .sardine)
    }
}
