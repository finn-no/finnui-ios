import SwiftUI

struct SavedSearchesSectionView: View {
    @ObservedObject var section: SavedSearchesSection
    var searchOverflowButtonAction: (SavedSearchViewModel) -> Void
    var searchSelectedAction: (SavedSearchViewModel) -> Void

    var body: some View {
        Section(header: SearchSectionHeaderView(text: section.title)) {
            ForEach(section.searches) { search in
                SavedSearchView(
                    savedSearch: search,
                    overflowButtonAction: { searchOverflowButtonAction(search) }
                ).onTapGesture {
                    searchSelectedAction(search)
                }

                if search != section.searches.last {
                    Divider().padding(.leading, .spacingM)
                }
            }
        }
    }
}

struct SavedSearchSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesSectionView(
            section: .init(
                title: "JOBB",
                searches: [.init(title: "Utvikler", text: "På FINN.no")]
            ),
            searchOverflowButtonAction: { _ in },
            searchSelectedAction: { _ in }
        )
    }
}
