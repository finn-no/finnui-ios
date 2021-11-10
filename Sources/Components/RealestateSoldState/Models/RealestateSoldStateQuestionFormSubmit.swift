import Foundation

public struct RealestateSoldStateQuestionFormSubmit {
    public let contactMethodIdentifier: String
    public let contactMethodValue: String
    public let questions: [String]

    public init(contactMethodIdentifier: String, contactMethodValue: String, questions: [String]) {
        self.contactMethodIdentifier = contactMethodIdentifier
        self.contactMethodValue = contactMethodValue
        self.questions = questions
    }
}
