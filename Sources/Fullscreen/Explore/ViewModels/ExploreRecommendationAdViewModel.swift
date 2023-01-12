import FinniversKit

final public class ExploreRecommendationAdViewModel: StandardAdRecommendationViewModel, Hashable {
    public let id: String
    public var imagePath: String?
    public var imageSize: CGSize
    public var iconImage: UIImage?
    public var title: String
    public var subtitle: String?
    public var accessory: String?
    public var imageText: String?
    public var isFavorite: Bool
    public var scaleImageToFillView: Bool
    public var sponsoredAdData: FinniversKit.SponsoredAdData?
    public var favoriteButtonAccessibilityLabel: String
    public var hideImageOverlay: Bool

    public init(imagePath: String? = nil, imageSize: CGSize, iconImage: UIImage? = nil, title: String, subtitle: String? = nil, accessory: String? = nil, imageText: String? = nil, isFavorite: Bool, scaleImageToFillView: Bool, sponsoredAdData: SponsoredAdData? = nil, favoriteButtonAccessibilityLabel: String, hideImageOverlay: Bool, id: String) {
        self.imagePath = imagePath
        self.imageSize = imageSize
        self.iconImage = iconImage
        self.title = title
        self.subtitle = subtitle
        self.accessory = accessory
        self.imageText = imageText
        self.isFavorite = isFavorite
        self.scaleImageToFillView = scaleImageToFillView
        self.sponsoredAdData = sponsoredAdData
        self.favoriteButtonAccessibilityLabel = favoriteButtonAccessibilityLabel
        self.hideImageOverlay = hideImageOverlay
        self.id = id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: ExploreRecommendationAdViewModel, rhs: ExploreRecommendationAdViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
