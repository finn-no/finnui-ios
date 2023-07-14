public class FiksFerdigShippingInfoCellViewModel {
    public struct ShippingProvider: RawRepresentable, Hashable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static var heltHjem: Self { Self(rawValue: "HELTHJEM") }
        public static var posten: Self { Self(rawValue: "POSTEN") }
        public static var postnord: Self { Self(rawValue: "POSTNORD") }
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
