import Foundation

public class RealestateSoldStateQuestionModel {
    public enum Kind {
        case provided
        case userFreetext
    }

    public let id: String
    public let kind: Kind
    public let title: String
    public var isSelected: Bool
    public var value: String?

    public init(id: String, kind: Kind, title: String, isSelected: Bool = false, value: String? = nil) {
        self.kind = kind
        self.id = id
        self.title = title
        self.isSelected = isSelected
        self.value = value
    }
}
