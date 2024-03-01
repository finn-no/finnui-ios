//
//  Copyright © 2018 FINN AS. All rights reserved.
//

@testable import Demo
@testable import FinnUI
import XCTest
import SwiftUI
import DemoKitSnapshot

class SwiftUIViewTests: XCTestCase {
    private func snapshot(_ component: SwiftUIDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testButtons() {
        snapshot(.buttons)
    }

    func testSettings() {
        snapshot(.settings)
    }

    func testBasicCellVariations() {
        snapshot(.basicCellVariations)
    }

    func testBapAdView() {
        snapshot(.bapAdView)
    }

    func testSavedSearches() {
        snapshot(.savedSearches)
    }
}
