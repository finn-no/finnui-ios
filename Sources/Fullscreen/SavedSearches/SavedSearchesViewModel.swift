import Foundation

public protocol SavedSearchesViewModel: ObservableObject {
    var title: String { get }
    var sortButtonTitle: String { get }
    var sections: [SavedSearchesSection] { get }
    func load()
    func sort()
}

public struct SavedSearchesSection: Identifiable {
    public let id = UUID()
    public let title: String
    public let searches: [SavedSearchViewModel]
}

public struct SavedSearchViewModel: Identifiable {
    public let id = UUID()
    public let title: String
    public let text: String
}
