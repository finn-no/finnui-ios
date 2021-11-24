import Foundation

public struct QuestionFormViewModel {
    public let questionsTitle: String
    public let questions: [RealestateSoldStateQuestionModel]
    public let contactMethod: ContactMethod?
    public let submitDisclaimer: String
    public let submitButtonTitle: String

    public init(
        questionsTitle: String,
        questions: [RealestateSoldStateQuestionModel],
        contactMethod: QuestionFormViewModel.ContactMethod?,
        submitDisclaimer: String,
        submitButtonTitle: String
    ) {
        self.questionsTitle = questionsTitle
        self.questions = questions
        self.contactMethod = contactMethod
        self.submitDisclaimer = submitDisclaimer
        self.submitButtonTitle = submitButtonTitle
    }

    public struct ContactMethod {
        public let title: String
        public let emailMethod: UserContactMethodSelectionModel.Email
        public let phoneMethod: UserContactMethodSelectionModel.Phone

        public init(title: String, emailMethod: UserContactMethodSelectionModel.Email, phoneMethod: UserContactMethodSelectionModel.Phone) {
            self.title = title
            self.emailMethod = emailMethod
            self.phoneMethod = phoneMethod
        }
    }
}
