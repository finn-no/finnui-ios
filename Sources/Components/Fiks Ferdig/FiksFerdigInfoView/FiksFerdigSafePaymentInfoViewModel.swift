import UIKit

public final class FiksFerdigSafePaymentInfoViewModel {
    public let timeLineItems: [TimeLineItem]
    public let headerViewModel: FiksFerdigInfoBaseViewModel

    public init(
        headerTitle: String,
        timeLineItems: [TimeLineItem]
    ) {
        self.timeLineItems = timeLineItems
        self.headerViewModel = FiksFerdigInfoBaseViewModel(
            title: headerTitle,
            icon: UIImage(named: .tjtLockShield)
        )
    }
}
