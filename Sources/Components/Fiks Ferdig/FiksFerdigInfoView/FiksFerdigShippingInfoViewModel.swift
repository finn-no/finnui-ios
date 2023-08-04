import UIKit

public class FiksFerdigShippingInfoViewModel {
    public let providers: [FiksFerdigShippingInfoCellViewModel]
    public let headerViewModel: FiksFerdigInfoBaseViewModel
    public let noProviderText: String

    public init(
        headerTitle: String,
        providers: [FiksFerdigShippingInfoCellViewModel],
        noProviderText: String
    ) {
        self.headerViewModel = FiksFerdigInfoBaseViewModel(
            title: headerTitle,
            icon: UIImage(named: .tjtShipmentInTransit)
        )
        self.noProviderText = noProviderText
        self.providers = providers
    }
}
