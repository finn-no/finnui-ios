import Combine
import FinniversKit
import UIKit

public class HeltHjemAccordionViewModel {
    public let providerName: String
    public let message: String
    public let headerViewModel: TJTAccordionViewModel

    public init(headerTitle: String, providerName: String, message: String, isExpanded: Bool = false) {
        self.headerViewModel = TJTAccordionViewModel(
            title: headerTitle,
            icon: UIImage(named: .shipmentInTransit),
            isExpanded: isExpanded
        )
        self.providerName = providerName
        self.message = message
    }
}

public final class HeltHjemAccordionView: TJTAccordionView {
    private let viewModel: HeltHjemAccordionViewModel

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

    private let heltHjemIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .helthjemIcon))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textContainerStackView = UIStackView(axis: .vertical)

    public init(viewModel: HeltHjemAccordionViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel.headerViewModel, withAutolayout: withAutoLayout)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        providerLabel.text = viewModel.providerName
        messageLabel.text = viewModel.message

        providerLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        heltHjemIcon.setContentHuggingPriority(.required, for: .horizontal)
        heltHjemIcon.setContentCompressionResistancePriority(.required, for: .horizontal)

        textContainerStackView.addArrangedSubviews([
            providerLabel,
            messageLabel
        ])

        containerStackView.addArrangedSubviews([
            heltHjemIcon,
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
