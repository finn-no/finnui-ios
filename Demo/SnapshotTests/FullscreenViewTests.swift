//
//  Copyright © 2018 FINN AS. All rights reserved.
//

@testable import Demo
import XCTest
import FinniversKit
import DemoKitSnapshot

class FullscreenViewTests: XCTestCase {
    private func snapshot(_ component: FullscreenDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testSnowGlobeView() {
        snapshot(.snowGlobeView)
    }

    func testSplashView() {
        snapshot(.splashView)
    }

    func testNewYearsView() {
        snapshot(.newYearsView)
    }

    func testFavoriteAdSortingView() {
        snapshot(.favoriteAdSortingView)
    }

    func testSavedSearchSortingView() {
        snapshot(.savedSearchSortingView)
    }

    func testSearchDropdown() {
        snapshot(.searchDropdown)
    }

    func testSearchSuggestions() {
        snapshot(.searchSuggestions)
    }

    func testExploreView() {
        snapshot(.exploreView)
    }

    func testExploreDetailView() {
        snapshot(.exploreDetailView)
    }

    func testStories() {
        snapshot(.stories)
    }
}
