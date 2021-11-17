import Foundation

public struct QuestionFormViewModel {
    public let questionsTitle: String
    public let questions: [RealestateSoldStateQuestionModel]
    public let contactMethodTitle: String
    public let contactMethodEmail: UserContactMethodSelectionModel.Email
    public let contactMethodPhone: UserContactMethodSelectionModel.Phone
    public let submitDisclaimer: String
    public let submitButtonTitle: String

    public init(
        questionsTitle: String,
        questions: [RealestateSoldStateQuestionModel],
        contactMethodTitle: String,
        contactMethodEmail: UserContactMethodSelectionModel.Email,
        contactMethodPhone: UserContactMethodSelectionModel.Phone,
        submitDisclaimer: String,
        submitButtonTitle: String
    ) {
        self.questionsTitle = questionsTitle
        self.questions = questions
        self.contactMethodTitle = contactMethodTitle
        self.contactMethodEmail = contactMethodEmail
        self.contactMethodPhone = contactMethodPhone
        self.submitDisclaimer = submitDisclaimer
        self.submitButtonTitle = submitButtonTitle
    }
}
