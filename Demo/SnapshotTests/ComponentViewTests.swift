//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import XCTest
import FinniversKit
import Demo

class ComponentViewTests: XCTestCase {
    private func snapshot(_ component: ComponentDemoViews, includeIPad: Bool = false, delay: TimeInterval? = nil, record recording: Bool = false, testName: String = #function) {
        assertSnapshots(matching: component.viewController, includeDarkMode: true, includeIPad: includeIPad, delay: delay, record: recording, testName: testName)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: ComponentDemoViews.self) {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

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
        snapshot(.realestateAgencyBanner, includeIPad: true)
    }

    func testRealestateSoldState() {
        snapshot(.realestateSoldState, includeIPad: true)
    }

    func testRealestateAgencyContent() {
        snapshot(.realestateAgencyContent, includeIPad: true)
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
        snapshot(.projectUnitsListView, includeIPad: true)
    }

    func testMotorSidebar() {
        snapshot(.motorSidebar, includeIPad: true)
    }
}
