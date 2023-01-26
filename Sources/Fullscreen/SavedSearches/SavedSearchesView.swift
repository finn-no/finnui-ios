import SwiftUI

public struct SavedSearchesView<ViewModel: SavedSearchesViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
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
                        Spacer().frame(height: .spacingXL)
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
        .onAppear {
            viewModel.load()
        }
    }
}

struct SavedSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesView(viewModel: SavedSearchesPreviewData())
    }
}
