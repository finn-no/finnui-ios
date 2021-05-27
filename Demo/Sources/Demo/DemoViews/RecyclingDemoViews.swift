//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum RecyclingDemoViews: String, DemoViews {
    case projectUnitsView
    case promotedRealestateCell

    public var viewController: UIViewController {
        switch self {
        case .projectUnitsView:
            return DemoViewController<ProjectUnitsDemoView>()
        case .promotedRealestateCell:
            return DemoViewController<PromotedRealestateCellDemoView>(dismissType: .dismissButton)
        }
    }
}
