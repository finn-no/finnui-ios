import Foundation

public struct RealestateSoldStateQuestionFormSubmit {
    public let contactMethodIdentifier: String
    public let contactMethodValue: String
<<<<<<< HEAD
    public let questions: [RealestateSoldStateQuestionModel]

    public init(contactMethodIdentifier: String, contactMethodValue: String, questions: [RealestateSoldStateQuestionModel]) {
        self.contactMethodIdentifier = contactMethodIdentifier
        self.contactMethodValue = contactMethodValue
=======
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
>>>>>>> master
        self.questions = questions
    }
}
