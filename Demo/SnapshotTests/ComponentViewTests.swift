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

    func testSaveSearchPromptView() {
        snapshot(.saveSearchPromptView)
    }

    func testSaveSearchView() {
        snapshot(.saveSearchView)
    }

    func testSearchListEmptyView() {
        snapshot(.searchListEmptyView)
    }

    func testChatAvailabilityView() {
        snapshot(.chatAvailabilityView)
    }

    func testIconLinkListView() {
        snapshot(.iconLinkListView)
    }

    func testSearchFilterTags() {
        snapshot(.searchFilterTags)
    }

    func testSearchDisplayMenuView() {
        snapshot(.searchDisplayMenuView)
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
}
