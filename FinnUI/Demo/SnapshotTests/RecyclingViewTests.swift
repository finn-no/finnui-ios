//
//  Copyright © 2018 FINN AS. All rights reserved.
//

@testable import Demo
import XCTest
import FinniversKit
import DemoKitSnapshot

class RecyclingViewTests: XCTestCase {
    private func snapshot(_ component: RecyclingDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testProjectUnitsView() {
        snapshot(.projectUnitsView)
    }
}
