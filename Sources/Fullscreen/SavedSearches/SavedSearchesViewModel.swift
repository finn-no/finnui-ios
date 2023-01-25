import Foundation

public protocol SavedSearchesViewModel: ObservableObject {
    var title: String { get }
    var sortButtonTitle: String { get }
    var sections: [SavedSearchesSection] { get }
    func load()
    func sort()
    func overflowAction(search: SavedSearchViewModel)
    func searchSelectedAction(search: SavedSearchViewModel)
}

public class SavedSearchesSection: Identifiable, ObservableObject {
    public let id = UUID()
    public let title: String
    @Published public var searches: [SavedSearchViewModel]

    init(title: String, searches: [SavedSearchViewModel]) {
        self.title = title
        self.searches = searches
    }
}

public class SavedSearchViewModel: Identifiable, ObservableObject, Equatable {
    public enum TextStyle {
        case active
        case inactive
    }

    public let id = UUID()
    @Published public var title: String
    @Published public var text: String
    @Published public var textStyle: TextStyle

    init(title: String, text: String, textStyle: TextStyle) {
        self.title = title
        self.text = text
        self.textStyle = textStyle
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: SavedSearchViewModel, rhs: SavedSearchViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
