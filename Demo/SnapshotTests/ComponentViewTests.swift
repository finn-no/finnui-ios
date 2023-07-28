//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import XCTest
import FinniversKit
@testable import Demo
import DemoKitSnapshot

class ComponentViewTests: XCTestCase {
    private func snapshot(_ component: ComponentDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testSaveSearchView() {
        snapshot(.saveSearchView)
    }

    func testChatAvailabilityView() {
        snapshot(.chatAvailabilityView)
    }

    func testIconLinkListView() {
        snapshot(.iconLinkListView)
    }

    func testExpandCollapseButton() {
        snapshot(.expandCollapseButton)
    }

    func testObjectPageBlinkView() {
        snapshot(.objectPageBlinkView)
    }

    func testSearchDropdownGroupView() {
        snapshot(.searchDropdownGroupView)
    }

    func testPopularSearchesView() {
        snapshot(.popularSearchesView)
    }

    func testTagCloudGridView() {
        snapshot(.tagCloudGridView)
    }

    func testAdTipsCollapsibleView() {
        snapshot(.adTipsCollapsibleView)
    }

    func testNumberedAdTipsCollapsibleView() {
        snapshot(.numberedAdTipsCollapsibleView)
    }

    func testHelthjemView() {
        snapshot(.helthjemView)
    }

    func testShippingAlternativesView() {
        snapshot(.shippingAlternativesView)
    }

    func testRealestateAgencyBanner() {
        snapshot(.realestateAgencyBanner)
    }

    func testRealestateSoldState() {
        snapshot(.realestateSoldState)
    }

    func testRealestateAgencyContent() {
        snapshot(.realestateAgencyContent)
    }

    func testRecommendationConsentView() {
        snapshot(.recommendationConsentView)
    }

    func testRecommendationEmptyView() {
        snapshot(.recommendationEmptyView)
    }

    func testFadedExpandableView() {
        snapshot(.fadedExpandableView)
    }

    func testExtendedProfileView() {
        snapshot(.extendedProfileView)
    }

    func testBasicProfileView() {
        snapshot(.basicProfileView)
    }

    func testSuggestShippingView() {
        snapshot(.suggestShippingView)
    }

    func testShippingRequestedView() {
        snapshot(.shippingRequestedView)
    }

    func testShippingRequestErrorView() {
        snapshot(.shippingRequestErrorView)
    }

    func testFiksFerdigPriceView() {
        snapshot(.fiksFerdigPriceView)
    }

    func testFiksFerdigAccordionView() {
        snapshot(.fiksFerdigAccordionView)
    }

    func testTimeLineView() {
        snapshot(.timeLineView)
    }

    func testFiksFerdigServiceInfoView() {
        snapshot(.fiksFerdigServiceInfoView)
    }

    func testFiksFerdigShippingInfoView() {
        snapshot(.fiksFerdigShippingInfoView)
    }

    func testFiksFerdigSafePaymentInfoView() {
        snapshot(.fiksFerdigSafePaymentInfoView)
    }

    func testFiksFerdigInfoView() {
        snapshot(.fiksFerdigInfoView)
    }

    func testFiksFerdigContactSellerView() {
        snapshot(.fiksFerdigContactSellerView)
    }

    func testProjectUnitsListView() {
        snapshot(.projectUnitsListView)
    }

    func testMotorSidebar() {
        snapshot(.motorSidebar)
    }
}
