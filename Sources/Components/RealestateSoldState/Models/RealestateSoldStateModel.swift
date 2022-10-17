import Foundation

public struct RealestateSoldStateModel {
    public let title: String
    public let logoUrl: String
    public let presentFormButtonTitle: String
    public let contactPerson: CompanyProfile.ContactPerson
    public let questionForm: QuestionFormViewModel
    public let companyProfile: CompanyProfileModel
    public let formSubmitted: RealestateSoldStateFormSubmittedModel
    public let style: Style

    public init(
        title: String,
        logoUrl: String,
        presentFormButtonTitle: String,
        contactPerson: CompanyProfile.ContactPerson,
        questionForm: QuestionFormViewModel,
        companyProfile: CompanyProfileModel,
        formSubmitted: RealestateSoldStateFormSubmittedModel,
        style: Style
    ) {
        self.title = title
        self.logoUrl = logoUrl
        self.presentFormButtonTitle = presentFormButtonTitle
        self.contactPerson = contactPerson
        self.questionForm = questionForm
        self.companyProfile = companyProfile
        self.formSubmitted = formSubmitted
        self.style = style
    }
}
