import Foundation

public struct QuestionFormViewModel {
    public let questionsTitle: String
    public let questions: [RealestateSoldStateQuestionModel]
    public let contactMethod: ContactMethod?
    public let submitDisclaimer: String
    public let submitButtonTitle: String
    public let userFreeTextCharacterLimit: Int
    public let userFreeTextCounterSuffix: String
    public let userFreeTextDisclaimer: String

    public init(
        questionsTitle: String,
        questions: [RealestateSoldStateQuestionModel],
        contactMethod: ContactMethod?,
        submitDisclaimer: String,
        submitButtonTitle: String,
        userFreeTextCharacterLimit: Int,
        userFreeTextCounterSuffix: String,
        userFreeTextDisclaimer: String
    ) {
        self.questionsTitle = questionsTitle
        self.questions = questions
        self.contactMethod = contactMethod
        self.submitDisclaimer = submitDisclaimer
        self.submitButtonTitle = submitButtonTitle
        self.userFreeTextCharacterLimit = userFreeTextCharacterLimit
        self.userFreeTextCounterSuffix = userFreeTextCounterSuffix
        self.userFreeTextDisclaimer = userFreeTextDisclaimer
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
