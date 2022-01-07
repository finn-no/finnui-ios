import Foundation

public struct RealestateSoldStateQuestionFormSubmit {
    public let contactMethodIdentifier: String
    public let contactMethodValue: String
    public let questions: [RealestateSoldStateQuestionModel]

    public init(contactMethodIdentifier: String, contactMethodValue: String, questions: [RealestateSoldStateQuestionModel]) {
        self.contactMethodIdentifier = contactMethodIdentifier
        self.contactMethodValue = contactMethodValue
        self.questions = questions
    }
}
