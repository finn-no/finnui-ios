//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit
import DemoKit

enum RecyclingDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case projectUnitsView

    static var groupTitle: String { "Recycling" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .projectUnitsView:
            return ProjectUnitsDemoView()
        }
    }
}
