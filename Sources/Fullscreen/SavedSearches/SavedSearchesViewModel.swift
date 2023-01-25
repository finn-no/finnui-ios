import Foundation

public protocol SavedSearchesViewModel: ObservableObject {
    var title: String { get }
    var sortButtonTitle: String { get }
    var sections: [SavedSearchesSection] { get }
    func load()
    func sort()
    func overflowAction(search: SavedSearchViewModel)
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

public class SavedSearchViewModel: Identifiable, ObservableObject {
    public let id = UUID()
    public let title: String
    public let text: String

    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}
