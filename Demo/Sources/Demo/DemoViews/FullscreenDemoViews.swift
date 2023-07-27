//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit
import DemoKit

enum FullscreenDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case snowGlobeView
    case newYearsView
    case splashView
    case savedSearchSortingView
    case favoriteAdSortingView
    case searchDropdown
    case searchSuggestions
    case exploreView
    case exploreDetailView
    case stories

    static var groupTitle: String { "Fullscreen" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .snowGlobeView:
            return SnowGlobeDemoView()
        case .newYearsView:
            return NewYearsDemoView()
        case .splashView:
            return SplashDemoView()
        case .favoriteAdSortingView:
            return FavoriteAdSortingDemoView()
        case .savedSearchSortingView:
            return SavedSearchSortingDemoView()
        case .searchDropdown:
            return SearchDropdownDemoView()
        case .searchSuggestions:
            return SearchSuggestionsDemoView()
        case .exploreView:
            return ExploreDemoViewController()
        case .exploreDetailView:
            return ExploreDetailDemoView()
        case .stories:
            return StoryDemoView()
        }
    }
}
