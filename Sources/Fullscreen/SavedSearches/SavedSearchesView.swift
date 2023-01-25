import SwiftUI

struct SavedSearchesView: View {
    public var viewModel: SavedSearchesViewModel

    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.searches) { search in
                        Text(search.title)
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
