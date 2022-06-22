import Combine
import FinniversKit
import UIKit

public protocol SafePaymentAccordionViewModelDelegate: AnyObject {
    func didChangeExpandedState(isExpanded: Bool)
}

public final class SafePaymentAccordionViewModel {
    public let timeLineItems: [TimeLineItem]
    public let headerViewModel: TJTAccordionViewModel
    public weak var delegate: SafePaymentAccordionViewModelDelegate?

    private var cancellable: AnyCancellable?

    internal init(headerTitle: String, timeLineItems: [TimeLineItem], isExpanded: Bool = false) {
        self.timeLineItems = timeLineItems
        self.headerViewModel = TJTAccordionViewModel(
            title: headerTitle,
            icon: UIImage(named: .lockShield),
            isExpanded: isExpanded
        )

        cancellable = headerViewModel
            .$isExpanded
            .sink { [weak self] isExpanded in
                self?.delegate?.didChangeExpandedState(isExpanded: isExpanded)
            }
    }
}

public final class SafePaymentAccordionView: TJTAccordionView {
    private let viewModel: SafePaymentAccordionViewModel
    private let simpleIndicatorProvider = SimpleTimeLineIndicatorProvider(font: .caption)

    private lazy var timeLineView: TimeLineView = {
        let timeLineView = TimeLineView(
            items: viewModel.timeLineItems,
            itemIndicatorProvider: simpleIndicatorProvider,
            withAutoLayout: true
        )
        timeLineView.layoutIfNeeded()
        return timeLineView
    }()

    public init(viewModel: SafePaymentAccordionViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel.headerViewModel, withAutolayout: withAutoLayout)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addViewToContentView(timeLineView)
    }
}
