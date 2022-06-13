import FinniversKit

public struct BasicProfileViewModel {
    public let companyName: String
    public let slogan: String?
    public let logoUrl: String
    public let contactPersons: [CompanyProfile.ContactPerson]
    public let buttonLinks: [LinkButtonViewModel]

    public init(
        companyName: String,
        slogan: String?,
        logoUrl: String,
        contactPersons: [CompanyProfile.ContactPerson],
        buttonLinks: [LinkButtonViewModel]
    ) {
        self.companyName = companyName
        self.slogan = slogan
        self.logoUrl = logoUrl
        self.contactPersons = contactPersons
        self.buttonLinks = buttonLinks
    }
}
