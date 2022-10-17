import UIKit
import FinniversKit

public protocol RealestateAgencyBannerViewDelegate: AnyObject {
    func realestateAgencyBannerViewDidSelectScrollButton(_ view: RealestateAgencyBannerView)
}

public class RealestateAgencyBannerView: UIView {

    // MARK: - Private properties

    private let viewModel: RealestateAgencyBannerViewModel
    private weak var delegate: RealestateAgencyBannerViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private lazy var logoImageWrapperView = RealestateAgencyLogoWrapperView(withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)

    private lazy var scrollButton: Button = {
        let style = Button.Style.flat.overrideStyle(
            textColor: viewModel.style.textColor,
            highlightedTextColor: viewModel.style.textColor.withAlphaComponent(0.7)
        )
        let button = Button(style: style, size: .small)
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public init(
        viewModel: RealestateAgencyBannerViewModel,
        delegate: RealestateAgencyBannerViewDelegate,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = viewModel.style.backgroundColor

        addSubview(stackView)
        stackView.fillInSuperview()
        stackView.addArrangedSubviews([logoImageWrapperView, UIView(withAutoLayout: true), scrollButton])

        logoImageWrapperView.configure(
            imageUrl: viewModel.logoUrl,
            backgroundColor: viewModel.style.logoBackgroundColor,
            remoteImageViewDataSource: remoteImageViewDataSource
        )
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.realestateAgencyBannerViewDidSelectScrollButton(self)
    }
}
