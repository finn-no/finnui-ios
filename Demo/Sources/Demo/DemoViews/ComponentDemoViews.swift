//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinnUI
import UIKit
import FinniversKit

public enum ComponentDemoViews: String, DemoViews {
    case saveSearchView
    case saveSearchPromptView
    case searchDisplayMenuView
    case searchFilterTags
    case searchListEmptyView
    case expandCollapseButton
    case objectPageBlinkView
    case chatAvailabilityView
    case iconLinkListView
    case searchDropdownGroupView
    case popularSearchesView

    public var viewController: UIViewController {
        switch self {
        case .saveSearchView:
            let demoViewController = DemoViewController<SaveSearchViewDemoView>()
            demoViewController.view.backgroundColor = .bgPrimary
            return BottomSheet(rootViewController: demoViewController)
        case .searchDisplayMenuView:
            return DemoViewController<SearchDisplayMenuDemoView>()
        case .saveSearchPromptView:
            return DemoViewController<SaveSearchPromptViewDemoView>()
        case .searchFilterTags:
            return DemoViewController<SearchFilterTagsDemoView>()
        case .searchListEmptyView:
            return DemoViewController<SearchListEmptyDemoView>()
        case .chatAvailabilityView:
            return DemoViewController<ChatAvailabilityDemoView>(dismissType: .dismissButton)
        case .iconLinkListView:
            return DemoViewController<IconLinkListViewDemo>()
        case .expandCollapseButton:
            return DemoViewController<ExpandCollapseButtonDemoView>()
        case .objectPageBlinkView:
            return DemoViewController<ObjectPageBlinkDemoView>()
        case .searchDropdownGroupView:
            return DemoViewController<SearchDropdownGroupDemoView>(dismissType: .dismissButton)
        case .popularSearchesView:
            return DemoViewController<PopularSearchesDemoView>(dismissType: .dismissButton)
        }
    }
}
