import Foundation

public struct QuestionFormViewModel {
    public let questionsTitle: String
    public let questions: [RealestateSoldStateQuestionModel]
    public let contactMethod: ContactMethod?
    public let userContactName: UserContactName
    public let submitDisclaimer: String
    public let submitButtonTitle: String
    public let userFreeTextCharacterLimit: Int
    public let userFreeTextCounterSuffix: String
    public let userFreeTextDisclaimer: String

    public init(
        questionsTitle: String,
        questions: [RealestateSoldStateQuestionModel],
        contactMethod: ContactMethod?,
        userContactName: UserContactName,
        submitDisclaimer: String,
        submitButtonTitle: String,
        userFreeTextCharacterLimit: Int,
        userFreeTextCounterSuffix: String,
        userFreeTextDisclaimer: String
    ) {
        self.questionsTitle = questionsTitle
        self.questions = questions
        self.contactMethod = contactMethod
        self.userContactName = userContactName
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

    public struct UserContactName {
        public let title: String
        public let initialValue: String?

        public init(title: String, initialValue: String? = nil) {
            self.title = title
            self.initialValue = initialValue
        }
    }
}
