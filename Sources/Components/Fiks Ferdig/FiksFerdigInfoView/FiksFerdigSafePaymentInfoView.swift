import Combine
import FinniversKit
import UIKit

public final class FiksFerdigSafePaymentInfoViewModel {
    public let timeLineItems: [TimeLineItem]
    public let headerViewModel: FiksFerdigAccordionViewModel

    public init(headerTitle: String, timeLineItems: [TimeLineItem], isExpanded: Bool = false) {
        self.timeLineItems = timeLineItems
        self.headerViewModel = FiksFerdigAccordionViewModel(
            title: headerTitle,
            icon: UIImage(named: .tjtLockShield),
            isExpanded: isExpanded
        )
    }
}

public final class FiksFerdigSafePaymentInfoView: FiksFerdigAccordionView {
    private let viewModel: FiksFerdigSafePaymentInfoViewModel
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

    public init(viewModel: FiksFerdigSafePaymentInfoViewModel, withAutoLayout: Bool = false) {
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
