//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum FullscreenDemoViews: String, DemoViews {
    case searchResultsView
    case snowGlobeView
    case newYearsView
    case splashView
    case savedSearchSortingView
    case searchDisplayTypeSelectionView
    case favoriteAdSortingView
    case searchDropdown
    case searchSuggestions

    public var viewController: UIViewController {
        switch self {
        case .searchResultsView:
            return DemoViewController<SearchResultsDemoView>(dismissType: .dismissButton)
        case .snowGlobeView:
            return DemoViewController<SnowGlobeDemoView>()
        case .newYearsView:
            return DemoViewController<NewYearsDemoView>()
        case .splashView:
            return DemoViewController<SplashDemoView>(constrainToTopSafeArea: false, constrainToBottomSafeArea: false)
        case .favoriteAdSortingView:
            return DemoViewController<FavoriteAdSortingDemoView>()
        case .savedSearchSortingView:
            return DemoViewController<SavedSearchSortingDemoView>()
        case .searchDisplayTypeSelectionView:
            return DemoViewController<SearchDisplayTypeSelectionDemoView>()
        case .searchDropdown:
            return DemoViewController<SearchDropdownDemoView>()
        case .searchSuggestions:
            return DemoViewController<SearchSuggestionsDemoView>()
        }
    }
}
