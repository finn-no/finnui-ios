import FinniversKit

public class UserContactMethodSelectionModel {
    public let identifier: String
    public let name: String
    public var isSelected: Bool
    public var value: String?

    public init(
        identifier: String,
        name: String,
        isSelected: Bool,
        value: String?
    ) {
        self.identifier = identifier
        self.name = name
        self.isSelected = isSelected
        self.value = value
    }

    public class Email: UserContactMethodSelectionModel {
        public let disclaimerText: String

        public init(identifier: String, name: String, disclaimerText: String, isSelected: Bool = false, value: String) {
            self.disclaimerText = disclaimerText
            super.init(
                identifier: identifier,
                name: name,
                isSelected: isSelected,
                value: value
            )
        }
    }

    public class Phone: UserContactMethodSelectionModel {
        public let textFieldPlaceholder: String

        public init(identifier: String, name: String, isSelected: Bool = false, value: String? = nil, textFieldPlaceholder: String) {
            self.textFieldPlaceholder = textFieldPlaceholder
            super.init(
                identifier: identifier,
                name: name,
                isSelected: isSelected,
                value: value
            )
        }
    }
}
