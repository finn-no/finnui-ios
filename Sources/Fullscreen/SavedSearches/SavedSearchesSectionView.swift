import SwiftUI

struct SavedSearchesSectionView: View {
    @ObservedObject var section: SavedSearchesSection

    var body: some View {
        Section(header: SearchSectionHeaderView(text: section.title)) {
            ForEach(section.searches) { search in
                SavedSearchView(savedSearch: search)
            }
        }
    }
}

struct SavedSearchSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesSectionView(section: .init(title: "Save", searches: []))
    }
}
