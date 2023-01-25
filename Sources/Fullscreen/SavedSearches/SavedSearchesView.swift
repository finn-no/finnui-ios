import SwiftUI

struct SavedSearchesView<ViewModel: SavedSearchesViewModel>: View {
    @StateObject public var viewModel: ViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.sections) { section in
                        SavedSearchesSectionView(
                            section: section,
                            searchOverflowButtonAction: { viewModel.overflowAction(search: $0)
                            },
                            searchSelectedAction: {
                                viewModel.searchSelectedAction(search: $0)
                            }
                        )
                    }
                }
                .padding([.top], .spacingM)
            }
            .background(Color.bgSecondary)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(viewModel.sortButtonTitle, action: {
                    withAnimation {
                        viewModel.sort()
                    }
                })
            }
        }
    }
}

struct SavedSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesView(viewModel: SavedSearchesPreviewData())
    }
}