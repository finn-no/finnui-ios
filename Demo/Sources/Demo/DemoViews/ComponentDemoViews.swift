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
    case tagCloudGridView
    case adTipsCollapsibleView
    case numberedAdTipsCollapsibleView
    case helthjemView
    case shippingAlternativesView
    case realestateSoldState
    case realestateAgencyContent
    case recommendationConsentView
    case recommendationEmptyView
    case fadedExpandableView
    case suggestShippingView
    case shippingRequestedView
    case shippingRequestErrorView
    case tjtAccordionView
    case timeLineView
    case fiksFerdigAccordionView
    case heltHjemAccordionView
    case safePaymentAccordionView
    case tjtSideBarView
    case tjtPriceView

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
        case .tagCloudGridView:
            return DemoViewController<TagCloudGridDemoView>()
        case .adTipsCollapsibleView:
            return DemoViewController<AdTipsCollapsibleDemoView>()
        case .numberedAdTipsCollapsibleView:
            return DemoViewController<NumberedAdTipsCollapsibleDemoView>()
        case .helthjemView:
            return DemoViewController<HelthjemDemoView>()
        case .shippingAlternativesView:
            return DemoViewController<ShippingAlternativesDemoView>()
        case .realestateSoldState:
            return DemoViewController<RealestateSoldStateDemoView>(dismissType: .dismissButton)
        case .realestateAgencyContent:
            return DemoViewController<RealestateAgencyContentDemoView>()
        case .recommendationConsentView:
            return DemoViewController<RecommendationConsentDemoView>()
        case .recommendationEmptyView:
            return DemoViewController<RecommendationEmptyDemoView>()
        case .fadedExpandableView:
            return DemoViewController<FadedExpandableDemoView>()
        case .tjtAccordionView:
            return DemoViewController<TJTAccordionDemoView>()
        case .suggestShippingView:
            return DemoViewController<SuggestShippingDemoView>()
        case .shippingRequestedView:
            return DemoViewController<ShippingRequestedDemoView>()
        case .shippingRequestErrorView:
            return DemoViewController<ShippingRequestErrorDemoView>()
        case .timeLineView:
            return DemoViewController<TimeLineDemoView>()
        case .fiksFerdigAccordionView:
            return DemoViewController<FiksFerdigAccordionDemoView>()
        case .heltHjemAccordionView:
            return DemoViewController<HeltHjemAccordionDemoView>()
        case .safePaymentAccordionView:
            return DemoViewController<SafePaymentAccordionDemoView>()
        case .tjtSideBarView:
            return DemoViewController<TJTSideBarDemoView>()
        case .tjtPriceView:
            return DemoViewController<TJTPriceDemoView>()
        }
    }
}
