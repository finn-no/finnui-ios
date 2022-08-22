public class FiksFerdigShippingInfoViewModel {
    public let provider: ShippingProvider
    public let providerName: String
    public let message: String
    public let headerViewModel: FiksFerdigAccordionViewModel

    public init(
        headerTitle: String,
        provider: ShippingProvider,
        providerName: String,
        message: String,
        isExpanded: Bool = false
    ) {
        self.headerViewModel = FiksFerdigAccordionViewModel(
            title: headerTitle,
            icon: UIImage(named: .tjtShipmentInTransit),
            isExpanded: isExpanded
        )
        self.provider = provider
        self.providerName = providerName
        self.message = message
    }
}

extension FiksFerdigShippingInfoViewModel {
    public enum ShippingProvider {
        case heltHjem
        case postnord
        case posten
    }
}
