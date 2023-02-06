import SwiftUI

public struct SavedSearchesListView<ViewModel: SavedSearchesListViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    var overflowAction: (SavedSearchViewModel) -> Void
    var tapAction: (SavedSearchViewModel) -> Void

    public init(
        viewModel: ViewModel,
        overflowAction: @escaping (SavedSearchViewModel) -> Void,
        tapAction: @escaping (SavedSearchViewModel) -> Void
    ) {
        self.viewModel = viewModel
        self.overflowAction = overflowAction
        self.tapAction = tapAction
    }

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.sections) { section in
                    SavedSearchesSectionView(
                        section: section,
                        searchOverflowButtonAction: {
                            overflowAction($0)
                        },
                        searchTappedAction: {
                            tapAction($0)
                        }
                    )
                    Spacer().frame(height: .spacingXL)
                }
            }
            .padding([.top], .spacingM)
        }
        .background(Color.bgSecondary)
    }
}

struct SavedSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesListView(viewModel: SavedSearchesListPreviewData(), overflowAction: {_ in }, tapAction: {_ in })
    }
}
