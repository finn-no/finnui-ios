import Combine
import FinniversKit
import UIKit

public protocol HeltHjemAccordionViewModelDelegate: AnyObject {
    func didChangeExpandedState(isExpanded: Bool)
}

public class HeltHjemAccordionViewModel {
    public let title: String
    public let providerName: String
    public let message: String
    public let headerViewModel: TJTAccordionViewModel

    public weak var delegate: HeltHjemAccordionViewModelDelegate?

    private var cancellable: AnyCancellable?

    public init(title: String, providerName: String, message: String, isExpanded: Bool = false) {
        self.title = title
        self.headerViewModel = TJTAccordionViewModel(
            title: title,
            icon: UIImage(named: .shipmentInTransit),
            isExpanded: isExpanded
        )
        self.providerName = providerName
        self.message = message

        cancellable = headerViewModel
            .$isExpanded
            .sink { [weak self] isExpanded in
                self?.delegate?.didChangeExpandedState(isExpanded: isExpanded)
            }
    }
}

public final class HeltHjemAccordionView: TJTAccordionView {
    private let viewModel: HeltHjemAccordionViewModel

    private let titleLabel: Label = {
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
        titleLabel.text = viewModel.title
        messageLabel.text = viewModel.message

        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        heltHjemIcon.setContentHuggingPriority(.required, for: .horizontal)
        heltHjemIcon.setContentCompressionResistancePriority(.required, for: .horizontal)

        textContainerStackView.addArrangedSubviews([
            titleLabel,
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
