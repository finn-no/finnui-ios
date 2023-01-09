import UIKit

public class FiksFerdigShippingInfoViewModel {
    public let providers: [FiksFerdigShippingInfoCellViewModel]
    public let headerViewModel: FiksFerdigAccordionViewModel
    public let noProviderText: String

    public init(
        headerTitle: String,
        providers: [FiksFerdigShippingInfoCellViewModel],
        noProviderText: String,
        isExpanded: Bool = false
    ) {
        self.headerViewModel = FiksFerdigAccordionViewModel(
            title: headerTitle,
            icon: UIImage(named: .tjtShipmentInTransit),
            isExpanded: isExpanded
        )
        self.noProviderText = noProviderText
        self.providers = providers
    }
}
