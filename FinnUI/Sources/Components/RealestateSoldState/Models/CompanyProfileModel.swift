import FinniversKit

public struct CompanyProfileModel {
    public let imageUrl: String
    public let slogan: String?
    public let buttonLinks: [LinkButtonViewModel]
    public let ctaButtonTitle: String?

    public init(imageUrl: String, slogan: String?, buttonLinks: [LinkButtonViewModel], ctaButtonTitle: String?) {
        self.imageUrl = imageUrl
        self.slogan = slogan
        self.buttonLinks = buttonLinks
        self.ctaButtonTitle = ctaButtonTitle
    }
}
