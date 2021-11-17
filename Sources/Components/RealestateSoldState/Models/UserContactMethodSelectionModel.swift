import FinniversKit

public class UserContactMethodSelectionModel {
    public let identifier: String
    public let name: String
    public let textFieldType: TextField.InputType
    public let textFieldPlaceholder: String
    public var isSelected: Bool
    public var value: String?

    public init(
        identifier: String,
        name: String,
        textFieldType: TextField.InputType,
        textFieldPlaceholder: String,
        isSelected: Bool = false,
        value: String? = nil
    ) {
        self.identifier = identifier
        self.name = name
        self.textFieldType = textFieldType
        self.textFieldPlaceholder = textFieldPlaceholder
        self.isSelected = isSelected
        self.value = value
    }
}
