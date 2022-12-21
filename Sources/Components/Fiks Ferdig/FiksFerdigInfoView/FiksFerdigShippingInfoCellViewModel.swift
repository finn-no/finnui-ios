public class FiksFerdigShippingInfoCellViewModel {
    public enum ShippingProvider {
        case heltHjem
        case postnord
        case posten
    }

    public let provider: ShippingProvider
    public let providerName: String
    public let message: String

    public init(
        provider: ShippingProvider,
        providerName: String,
        message: String
    ) {
        self.provider = provider
        self.providerName = providerName
        self.message = message
    }
}
