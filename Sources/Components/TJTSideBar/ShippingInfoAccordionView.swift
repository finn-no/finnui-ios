import Combine
import FinniversKit
import UIKit

public class ShippingInfoAccordionViewModel {
    public let provider: ShippingProvider
    public let providerName: String
    public let message: String
    public let headerViewModel: TJTAccordionViewModel

    public init(
        headerTitle: String,
        provider: ShippingProvider,
        providerName: String,
        message: String,
        isExpanded: Bool = false
    ) {
        self.headerViewModel = TJTAccordionViewModel(
            title: headerTitle,
            icon: UIImage(named: .tjtShipmentInTransit),
            isExpanded: isExpanded
        )
        self.provider = provider
        self.providerName = providerName
        self.message = message
    }
}

extension ShippingInfoAccordionViewModel {
    public enum ShippingProvider {
        case heltHjem
        case postnord
    }
}

public final class HeltHjemAccordionView: TJTAccordionView {
    private let viewModel: ShippingInfoAccordionViewModel

    private let providerLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()

    private let messageLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()

    private let containerStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.alignment = .center
        stackView.spacing = .spacingS + .spacingXS
        return stackView
    }()

    private var providerIcon: UIImage {
        switch viewModel.provider {
        case .heltHjem:
            return UIImage(named: .tjtHelthjemIcon)
        case .postnord:
            return UIImage(named: .tjtPostnordIcon)
        }
    }

    private let providerIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textContainerStackView = UIStackView(axis: .vertical)

    public init(viewModel: ShippingInfoAccordionViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel.headerViewModel, withAutolayout: withAutoLayout)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        providerIconView.image = providerIcon
        providerLabel.text = viewModel.providerName
        messageLabel.text = viewModel.message

        providerLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        providerIconView.setContentHuggingPriority(.required, for: .horizontal)
        providerIconView.setContentCompressionResistancePriority(.required, for: .horizontal)

        textContainerStackView.addArrangedSubviews([
            providerLabel,
            messageLabel
        ])

        containerStackView.addArrangedSubviews([
            providerIconView,
            textContainerStackView
        ])

        addViewToContentView(containerStackView)
    }
}

private extension Button.Style {
    static var fiksFerdigAccordionButtonStyle: Button.Style {
        .flat
        .overrideStyle(normalFont: .captionStrong)
    }
}
