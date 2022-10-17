import FinniversKit

public struct ExtendedProfileViewModel {
    public let companyName: String
    public let slogan: String?
    public let logoUrl: String
    public let contactPersons: [CompanyProfile.ContactPerson]
    public let style: CompanyProfile.ProfileStyle
    public let buttonLinks: [LinkButtonViewModel]
    public let actionButtonTitle: String?

    public init(
        companyName: String,
        slogan: String?,
        logoUrl: String,
        contactPersons: [CompanyProfile.ContactPerson],
        style: CompanyProfile.ProfileStyle,
        buttonLinks: [LinkButtonViewModel],
        actionButtonTitle: String?
    ) {
        self.companyName = companyName
        self.slogan = slogan
        self.logoUrl = logoUrl
        self.contactPersons = contactPersons
        self.style = style
        self.buttonLinks = buttonLinks
        self.actionButtonTitle = actionButtonTitle
    }
}
