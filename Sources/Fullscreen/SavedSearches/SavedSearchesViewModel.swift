import Foundation

public protocol SavedSearchesViewModel: ObservableObject {
    var title: String { get }
    var sortButtonTitle: String { get }
    var sections: [SavedSearchesSection] { get }
    func load()
    func sort()
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

public struct SavedSearchViewModel: Identifiable {
    public let id = UUID()
    public let title: String
    public let text: String
}
