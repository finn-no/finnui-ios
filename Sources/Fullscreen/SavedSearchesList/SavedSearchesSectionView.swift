import SwiftUI

struct SavedSearchesSectionView: View {
    @ObservedObject var section: SavedSearchesSectionViewModel
    var searchOverflowButtonAction: (SavedSearchViewModel) -> Void
    var searchTappedAction: (SavedSearchViewModel) -> Void

    var body: some View {
        Section(header: SearchSectionHeaderView(text: section.title)) {
            ForEach(section.searches) { search in
                SavedSearchView(
                    savedSearch: search,
                    overflowButtonAction: { searchOverflowButtonAction(search) }
                )
                .onTapGesture {
                    searchTappedAction(search)
                }

                if search != section.searches.last {
                    Divider().padding(.leading, .spacingM)
                }
            }
        }
    }
}

//swiftlint:disable:next type_name superfluous_disable_command
struct SavedSearchSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesSectionView(
            section: .init(
                title: "JOBB",
                searches: [.init(title: "Utvikler", text: "På FINN.no", textStyle: .active)]
            ),
            searchOverflowButtonAction: { _ in },
            searchTappedAction: { _ in }
        )
    }
}
