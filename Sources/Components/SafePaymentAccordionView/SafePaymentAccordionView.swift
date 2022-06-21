import UIKit
import FinniversKit

public struct SafePaymentAccordionViewModel {
    public let headerViewModel: TJTAccordionViewModel
    public let timeLineItems: [TimeLineItem]

    internal init(headerViewModel: TJTAccordionViewModel, timeLineItems: [TimeLineItem]) {
        self.headerViewModel = headerViewModel
        self.timeLineItems = timeLineItems
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
