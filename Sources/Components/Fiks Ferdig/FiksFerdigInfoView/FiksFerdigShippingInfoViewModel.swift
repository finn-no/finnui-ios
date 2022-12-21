import UIKit

public class FiksFerdigShippingInfoViewModel {
    public let providers: [FiksFerdigShippingInfoCellViewModel]
    public let headerViewModel: FiksFerdigAccordionViewModel

    public init(
        headerTitle: String,
        providers: [FiksFerdigShippingInfoCellViewModel],
        isExpanded: Bool = false
    ) {
        self.headerViewModel = FiksFerdigAccordionViewModel(
            title: headerTitle,
            icon: UIImage(named: .tjtShipmentInTransit),
            isExpanded: isExpanded
        )
        self.providers = providers
    }
}
