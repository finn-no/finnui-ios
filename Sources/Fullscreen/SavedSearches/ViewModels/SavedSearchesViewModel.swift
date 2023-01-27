import Foundation

public protocol SavedSearchesViewModel: ObservableObject {
    var title: String { get }
    var sortButtonTitle: String { get }
    var sections: [SavedSearchesSectionViewModel] { get }
    func onAppear()
    func sort()
    func overflowAction(search: SavedSearchViewModel)
    func searchSelectedAction(search: SavedSearchViewModel)
}
