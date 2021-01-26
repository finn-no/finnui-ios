//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum RecyclingDemoViews: String, DemoViews {
    case projectUnitsView

    public var viewController: UIViewController {
        switch self {
        case .projectUnitsView:
            return DemoViewController<ProjectUnitsDemoView>()
        }
    }
}
