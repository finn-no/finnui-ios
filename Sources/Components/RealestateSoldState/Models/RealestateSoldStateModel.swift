import Foundation

public struct RealestateSoldStateModel {
    public let agentProfile: AgentProfileModel
    public let questionForm: QuestionFormViewModel

    public init(agentProfile: AgentProfileModel, questionForm: QuestionFormViewModel) {
        self.agentProfile = agentProfile
        self.questionForm = questionForm
    }
}
