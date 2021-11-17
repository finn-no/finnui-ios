import Foundation

public struct RealestateSoldStateModel {
    public let agentProfile: AgentProfileModel
    public let questionForm: QuestionFormViewModel
    public let companyProfile: CompanyProfileModel

    public init(
        agentProfile: AgentProfileModel,
        questionForm: QuestionFormViewModel,
        companyProfile: CompanyProfileModel
    ) {
        self.agentProfile = agentProfile
        self.questionForm = questionForm
        self.companyProfile = companyProfile
    }
}
