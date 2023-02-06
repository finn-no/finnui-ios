import Foundation

public class SavedSearchesSectionViewModel: Identifiable, ObservableObject {
    public let id = UUID()
    public let title: String
    @Published public var searches: [SavedSearchViewModel]

    public init(title: String, searches: [SavedSearchViewModel]) {
        self.title = title
        self.searches = searches
    }
}
