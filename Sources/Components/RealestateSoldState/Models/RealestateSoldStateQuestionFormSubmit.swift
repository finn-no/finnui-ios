import Foundation

public struct RealestateSoldStateQuestionFormSubmit {
    public let contactMethodIdentifier: String
    public let contactMethodValue: String
    public let userContactName: String?
    public let questions: [RealestateSoldStateQuestionModel]

    public init(
        contactMethodIdentifier: String,
        contactMethodValue: String,
        userContactName: String?,
        questions: [RealestateSoldStateQuestionModel]
    ) {
        self.contactMethodIdentifier = contactMethodIdentifier
        self.contactMethodValue = contactMethodValue
        self.userContactName = userContactName
        self.questions = questions
    }
}
