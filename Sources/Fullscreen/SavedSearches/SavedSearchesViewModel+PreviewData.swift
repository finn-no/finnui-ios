import Foundation

extension SavedSearchesViewModel {
    static let previewData: SavedSearchesViewModel = SavedSearchesViewModel(
        sections: [
            SavedSearchesSection(
                title: "Torget",
                searches: [
                    .init(title: "iPod Classic", text: "På FINN.no, E-post og Push varsling"),
                    .init(title: "Skinnsofa", text: "Kun Push-varsling"),
                    .init(title: "Hipster DBS sykkel", text: "Ingen aktive varsler"),
                    .init(title: "Fender Jaguar", text: "Kun på FINN.no"),
                    .init(title: "OP-1 Syntesizer", text: "På FINN.no, E-post og Push varsling")
                ]
            )
        ]
    )
}
