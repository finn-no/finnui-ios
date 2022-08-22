import Combine
import FinniversKit
import UIKit

public final class FiksFerdigShippingInfoView: FiksFerdigAccordionView {
    private let viewModel: FiksFerdigShippingInfoViewModel

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
        case .posten:
            return UIImage(named: .tjtPostenIcon)
        }
    }

    private let providerIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textContainerStackView = UIStackView(axis: .vertical)

    public init(viewModel: FiksFerdigShippingInfoViewModel, withAutoLayout: Bool = false) {
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
