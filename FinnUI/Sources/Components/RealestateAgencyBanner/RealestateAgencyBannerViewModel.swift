import UIKit

public struct RealestateAgencyBannerViewModel {
    public let logoUrl: String
    public let buttonTitle: String
    public let style: CompanyProfile.ProfileStyle

    public init(logoUrl: String, buttonTitle: String, style: CompanyProfile.ProfileStyle) {
        self.logoUrl = logoUrl
        self.buttonTitle = buttonTitle
        self.style = style
    }
}
