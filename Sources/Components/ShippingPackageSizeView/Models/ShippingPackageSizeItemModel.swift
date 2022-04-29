import UIKit

public struct ShippingPackageSizeItemModel {

    // MARK: - Public properties

    public let size: Size
    public let title: String
    public let body: String
    public let helpText: String?
    public let isInitiallySelected: Bool

    // MARK: - Internal properties

    var image: UIImage {
        switch size {
        case .small:
            return UIImage(named: .headset)
        case .large:
            return UIImage(named: .mixer)
        case .extraLarge:
            return UIImage(named: .lamp)
        }
    }

    // MARK: - Init

    public init(size: Size, title: String, body: String, helpText: String?, isInitiallySelected: Bool) {
        self.size = size
        self.title = title
        self.body = body
        self.helpText = helpText
        self.isInitiallySelected = isInitiallySelected
    }
}

extension ShippingPackageSizeItemModel {
    public enum Size {
        case small
        case large
        case extraLarge
    }
}
