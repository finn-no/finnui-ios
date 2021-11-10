import Foundation

public class UserContactInformationViewModel {
    public let title: String
    public let contactMethods: [UserContactMethodSelectionModel]

    public init(title: String, contactMethods: [UserContactMethodSelectionModel]) {
        self.title = title
        self.contactMethods = contactMethods
    }
}
