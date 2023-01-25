import Foundation

protocol SavedSearchesViewModel {
    var sections: [SavedSearchesSection] { get }
    func load()
    func reorder()
}

struct SavedSearchesSection: Identifiable {
    let id = UUID()
    let title: String
    let searches: [SavedSearchViewModel]
}

struct SavedSearchViewModel: Identifiable {
    let id = UUID()
    let title: String
    let text: String
}
