import Foundation

public struct QuestionFormViewModel {
    public let questionsTitle: String
    public let questions: [RealestateSoldStateQuestionModel]
    public let contactMethodTitle: String
    public let contactMethodModels: [UserContactMethodSelectionModel]
    public let submitDisclaimer: String
    public let submitButtonTitle: String

    public init(
        questionsTitle: String,
        questions: [RealestateSoldStateQuestionModel],
        contactMethodTitle: String,
        contactMethodModels: [UserContactMethodSelectionModel],
        submitDisclaimer: String,
        submitButtonTitle: String
    ) {
        self.questionsTitle = questionsTitle
        self.questions = questions
        self.contactMethodTitle = contactMethodTitle
        self.contactMethodModels = contactMethodModels
        self.submitDisclaimer = submitDisclaimer
        self.submitButtonTitle = submitButtonTitle
    }
}
