import Foundation
import SwiftUI
import FinniversKit

public protocol SavedSearchesViewModel: ObservableObject {
    var title: String { get }
    var sortButtonTitle: String { get }
    var sections: [SavedSearchesSectionViewModel] { get }
    var toastViewModel: Toast.ViewModel? { get set }
    func onAppear()
    func sort()
    func overflowAction(search: SavedSearchViewModel)
    func searchSelectedAction(search: SavedSearchViewModel)
}
