import Foundation

public struct RealestateSoldStateModel {
    public let title: String
    public let logoUrl: String
    public let presentFormButtonTitle: String
<<<<<<< HEAD
    public let agentProfile: AgentProfileModel
    public let questionForm: QuestionFormViewModel
    public let companyProfile: CompanyProfileModel
    public let formSubmitted: RealestateSoldStateFormSubmittedModel
    public let styling: Styling
=======
    public let contactPerson: CompanyProfile.ContactPerson
    public let questionForm: QuestionFormViewModel
    public let companyProfile: CompanyProfileModel
    public let formSubmitted: RealestateSoldStateFormSubmittedModel
    public let style: Style
>>>>>>> master

    public init(
        title: String,
        logoUrl: String,
        presentFormButtonTitle: String,
<<<<<<< HEAD
        agentProfile: AgentProfileModel,
        questionForm: QuestionFormViewModel,
        companyProfile: CompanyProfileModel,
        formSubmitted: RealestateSoldStateFormSubmittedModel,
        styling: Styling
=======
        contactPerson: CompanyProfile.ContactPerson,
        questionForm: QuestionFormViewModel,
        companyProfile: CompanyProfileModel,
        formSubmitted: RealestateSoldStateFormSubmittedModel,
        style: Style
>>>>>>> master
    ) {
        self.title = title
        self.logoUrl = logoUrl
        self.presentFormButtonTitle = presentFormButtonTitle
<<<<<<< HEAD
        self.agentProfile = agentProfile
        self.questionForm = questionForm
        self.companyProfile = companyProfile
        self.formSubmitted = formSubmitted
        self.styling = styling
=======
        self.contactPerson = contactPerson
        self.questionForm = questionForm
        self.companyProfile = companyProfile
        self.formSubmitted = formSubmitted
        self.style = style
>>>>>>> master
    }
}
