import SwiftUI

struct SavedSearchesSectionView: View {
    @ObservedObject var section: SavedSearchesSection

    var body: some View {
        Section(header: SearchSectionHeaderView(text: section.title)) {
            ForEach(section.searches) { search in
                Text(search.title)
            }
        }
    }
}

struct SavedSearchSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesSectionView(section: .init(title: "Save", searches: []))
    }
}
