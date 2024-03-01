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
            if UIAccessibility.isVoiceOverRunning {
                accessibleStack
            } else {
                LazyVStack(alignment: .leading, spacing: 0) {
                    sectionViews
                }
                .padding([.top], .spacingM)
            }
        }
        .background(Color.bgSecondary)
    }

    private var sectionViews: some View {
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

    // Lazy loading is disabled for VoiceOver,
    // since all section headers need to be rendered up front to be accessible.
    private var accessibleStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionViews
        }
        .padding([.top], .spacingM)
    }
}

//swiftlint:disable:next type_name superfluous_disable_command
struct SavedSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchesListView(viewModel: SavedSearchesListPreviewData(), overflowAction: {_ in }, tapAction: {_ in })
    }
}
