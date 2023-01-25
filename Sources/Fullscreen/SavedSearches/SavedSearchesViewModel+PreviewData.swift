import Foundation

class SavedSearchesPreviewData: SavedSearchesViewModel, ObservableObject {
    let title: String = "Lagrede søk"
    let sortButtonTitle: String = "Sortering"

    @Published var sections: [SavedSearchesSection] = [
        SavedSearchesSection(
            title: "TORGET",
            searches: [
                .init(title: "iPod Classic", text: "På FINN.no, E-post og Push varsling"),
                .init(title: "Skinnsofa", text: "Kun Push-varsling"),
                .init(title: "Hipster DBS sykkel", text: "Ingen aktive varsler"),
                .init(title: "Fender Jaguar", text: "Kun på FINN.no"),
                .init(title: "OP-1 Syntesizer", text: "På FINN.no, E-post og Push varsling")
            ]
        ),
        SavedSearchesSection(
            title: "EIENDOM",
            searches: [
                .init(title: "Valdresgata", text: "Ingen aktive varslinger"),
                .init(title: "Bolig til salgs - 'Strandlinje med Jacuzzi', Fra 250 m², Eiendom", text: "På FINN.no, E-post og Push varsling")
            ]
        ),
        SavedSearchesSection(
            title: "JOBB",
            searches: [
                .init(title: "UX designer - Oslo", text: "Kun på FINN.no")
            ]
        ),
        SavedSearchesSection(
            title: "BIL",
            searches: [
                .init(title: "Volvo", text: "Ingen aktive varsler"),
                .init(title: "Lastebil, fra 800 000 kr", text: "Ingen aktive varsler")
            ]
        )
    ]

    func load() {}

    func sort() {
        sections.forEach({
            $0.searches.shuffle()
        })
    }

    func overflowAction(search: SavedSearchViewModel) {
        print("Did tap overflow menu for search with title", search.title)
    }
}
