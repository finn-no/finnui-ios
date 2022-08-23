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
