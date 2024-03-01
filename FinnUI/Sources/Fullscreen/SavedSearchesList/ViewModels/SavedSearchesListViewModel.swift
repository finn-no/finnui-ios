import Foundation
import SwiftUI

public protocol SavedSearchesListViewModel: ObservableObject {
    var sections: [SavedSearchesSectionViewModel] { get }
}
