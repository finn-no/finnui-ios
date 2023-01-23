import Foundation

struct SavedSearchesViewModel {
    let sections: [SavedSearchesSection]
}

struct SavedSearchesSection {
    let title: String
    let searches: [SavedSearchViewModel]
}

struct SavedSearchViewModel {
    let title: String
    let text: String
}
