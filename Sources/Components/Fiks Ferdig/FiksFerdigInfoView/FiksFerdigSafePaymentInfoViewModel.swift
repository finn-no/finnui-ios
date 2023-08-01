import UIKit

public final class FiksFerdigSafePaymentInfoViewModel {
    public let title: String
    public let icon: UIImage
    public let timeLineItems: [TimeLineItem]

    public init(
        headerTitle: String,
        icon: UIImage? = nil,
        timeLineItems: [TimeLineItem]
    ) {
        self.title = headerTitle
        self.icon = icon ?? UIImage(named: .tjtLockShield)
        self.timeLineItems = timeLineItems
    }
}
