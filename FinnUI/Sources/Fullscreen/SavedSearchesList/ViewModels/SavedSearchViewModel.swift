import Foundation

public class SavedSearchViewModel: Identifiable, ObservableObject {
    public enum TextStyle {
        case active
        case inactive
    }

    public let id = UUID()
    @Published public var title: String
    @Published public var text: String
    @Published public var textStyle: TextStyle

    public init(title: String, text: String, textStyle: TextStyle) {
        self.title = title
        self.text = text
        self.textStyle = textStyle
    }
}

extension SavedSearchViewModel: Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: SavedSearchViewModel, rhs: SavedSearchViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
