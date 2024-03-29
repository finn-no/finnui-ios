//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinnUI
import UIKit
import FinniversKit
import DemoKit

enum ComponentDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case saveSearchView
    case expandCollapseButton
    case objectPageBlinkView
    case chatAvailabilityView
    case iconLinkListView
    case searchDropdownGroupView
    case popularSearchesView
    case tagCloudGridView
    case adTipsCollapsibleView
    case numberedAdTipsCollapsibleView
    case realestateAgencyBanner
    case realestateSoldState
    case realestateAgencyContent
    case recommendationConsentView
    case recommendationEmptyView
    case fadedExpandableView
    case extendedProfileView
    case basicProfileView
    case projectUnitsListView

    static var groupTitle: String { "Components" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .saveSearchView:
            return SaveSearchViewDemoView()
        case .chatAvailabilityView:
            return ChatAvailabilityDemoView()
        case .iconLinkListView:
            return IconLinkListViewDemo()
        case .expandCollapseButton:
            return ExpandCollapseButtonDemoView()
        case .objectPageBlinkView:
            return ObjectPageBlinkDemoView()
        case .searchDropdownGroupView:
            return SearchDropdownGroupDemoView()
        case .popularSearchesView:
            return PopularSearchesDemoView()
        case .tagCloudGridView:
            return TagCloudGridDemoView()
        case .adTipsCollapsibleView:
            return AdTipsCollapsibleDemoView()
        case .numberedAdTipsCollapsibleView:
            return NumberedAdTipsCollapsibleDemoView()
        case .realestateAgencyBanner:
            return RealestateAgencyBannerDemoView()
        case .realestateSoldState:
            return RealestateSoldStateDemoView()
        case .realestateAgencyContent:
            return RealestateAgencyContentDemoView()
        case .recommendationConsentView:
            return RecommendationConsentDemoView()
        case .recommendationEmptyView:
            return RecommendationEmptyDemoView()
        case .fadedExpandableView:
            return FadedExpandableDemoView()
        case .extendedProfileView:
            return ExtendedProfileDemoView()
        case .basicProfileView:
            return BasicProfileDemoView()
        case .projectUnitsListView:
            return ProjectUnitsListDemoView()
        }
    }
}
