import SwiftUI

struct SavedSearchesView: View {
    public var viewModel: SavedSearchesViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.sections) { section in
                    Section(header: SearchSectionHeaderView(text: section.title)) {
                        ForEach(section.searches) { search in
                            Text(search.title)
                        }
                    }
                }
            }
        }
    }
}

struct SavedSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesView(viewModel: SavedSearchesPreviewData())
    }
}
