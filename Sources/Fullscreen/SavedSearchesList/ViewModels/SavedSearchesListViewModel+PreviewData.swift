import Foundation
import SwiftUI
import FinniversKit

class SavedSearchesListPreviewData: SavedSearchesListViewModel, ObservableObject {
    @Published var sections: [SavedSearchesSectionViewModel] = [
        SavedSearchesSectionViewModel(
            title: "TORGET",
            searches: [
                .init(title: "iPod Classic", text: "På FINN.no, E-post og Push varsling", textStyle: .active),
                .init(title: "Skinnsofa", text: "Kun Push-varsling", textStyle: .active),
                .init(title: "Hipster DBS sykkel", text: "Ingen aktive varsler", textStyle: .inactive),
                .init(title: "Fender Jaguar", text: "Kun på FINN.no", textStyle: .active),
                .init(title: "OP-1 Syntesizer", text: "På FINN.no, E-post og Push varsling", textStyle: .active)
            ]
        ),
        SavedSearchesSectionViewModel(
            title: "EIENDOM",
            searches: [
                .init(title: "Valdresgata", text: "Ingen aktive varslinger", textStyle: .inactive),
                .init(title: "Bolig til salgs - 'Strandlinje med Jacuzzi', Fra 250 m², Eiendom", text: "På FINN.no, E-post og Push varsling", textStyle: .active)
            ]
        ),
        SavedSearchesSectionViewModel(
            title: "JOBB",
            searches: [
                .init(title: "UX designer - Oslo", text: "Kun på FINN.no", textStyle: .active)
            ]
        ),
        SavedSearchesSectionViewModel(
            title: "BIL",
            searches: [
                .init(title: "Volvo", text: "Ingen aktive varsler", textStyle: .inactive),
                .init(title: "Lastebil, fra 800 000 kr", text: "Ingen aktive varsler", textStyle: .inactive)
            ]
        )
    ]

    func overflowAction(search: SavedSearchViewModel) {
        print("Tapped overflow button for search with title", search.title)
    }

    func searchSelectedAction(search: SavedSearchViewModel) {
        print("Tapped search with title", search.title)
    }
}
