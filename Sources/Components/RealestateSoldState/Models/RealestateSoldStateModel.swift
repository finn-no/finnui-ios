import Foundation

public struct RealestateSoldStateModel {
    public let title: String
    public let logoUrl: String
    public let agentProfile: AgentProfileModel
    public let questionForm: QuestionFormViewModel
    public let companyProfile: CompanyProfileModel
    public let styling: Styling

    public init(
        title: String,
        logoUrl: String,
        agentProfile: AgentProfileModel,
        questionForm: QuestionFormViewModel,
        companyProfile: CompanyProfileModel,
        styling: Styling
    ) {
        self.title = title
        self.logoUrl = logoUrl
        self.agentProfile = agentProfile
        self.questionForm = questionForm
        self.companyProfile = companyProfile
        self.styling = styling
    }
}
