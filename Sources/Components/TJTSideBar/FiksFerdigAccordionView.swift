import Combine
import FinniversKit
import UIKit

public protocol FiksFerdigAccordionViewModelDelegate: AnyObject {
    func didTapReadMoreURL(_ url: URL)
}

public final class FiksFerdigAccordionViewModel {
    public let message: String
    public let timeLineItems: [TimeLineItem]
    public let readMoreTitle: String
    public let readMoreURL: URL
    public let headerViewModel: TJTAccordionViewModel
    public weak var delegate: FiksFerdigAccordionViewModelDelegate?

    public init(
        headerTitle: String,
        message: String,
        timeLineItems: [TimeLineItem],
        readMoreTitle: String,
        readMoreURL: URL,
        isExpanded: Bool = false
    ) {
        self.message = message
        self.timeLineItems = timeLineItems
        self.readMoreTitle = readMoreTitle
        self.readMoreURL = readMoreURL
        self.headerViewModel = TJTAccordionViewModel(
            title: headerTitle,
            icon: UIImage(named: .torgetShipping),
            isExpanded: isExpanded
        )
    }

    func displayHelp() {
        delegate?.didTapReadMoreURL(readMoreURL)
    }
}

public final class FiksFerdigAccordionView: TJTAccordionView {
    private let viewModel: FiksFerdigAccordionViewModel
    private let dottedIndicatorProvider = DottedTimeLineIndicatorProvider(font: .caption)
    private let messageLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textColor = .textPrimary
        return label
    }()

    private var cancellable: AnyCancellable?

    private lazy var timeLineView: TimeLineView = {
        let timeLineView = TimeLineView(
            items: viewModel.timeLineItems,
            itemIndicatorProvider: dottedIndicatorProvider,
            withAutoLayout: true
        )
        timeLineView.layoutIfNeeded()
        return timeLineView
    }()

    private let readMoreButton: Button = {
        let button = Button(style: .fiksFerdigAccordionButtonStyle)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = .zero
        return button
    }()

    public init(viewModel: FiksFerdigAccordionViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel.headerViewModel, withAutolayout: withAutoLayout)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        messageLabel.text = viewModel.message
        readMoreButton.setTitle(viewModel.readMoreTitle, for: .normal)

        addViewToContentView(messageLabel, withSpacing: .spacingS)
        addViewToContentView(timeLineView)
        addViewToContentView(readMoreButton)

        cancellable = readMoreButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.displayHelp()
            }
    }
}

private extension Button.Style {
    static var fiksFerdigAccordionButtonStyle: Button.Style {
        .flat
        .overrideStyle(normalFont: .captionStrong)
    }
}
