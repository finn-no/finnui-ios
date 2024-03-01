//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
@testable import FinnUI
import DemoKit

enum SwiftUIDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case buttons
    case settings
    case basicCellVariations
    case bapAdView
    case savedSearches

    static var groupTitle: String { "SwiftUI" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .buttons:
            return ButtonStyleUsageDemoView_Previews()
        case .settings:
            return SettingsView_Previews()
        case .basicCellVariations:
            return BasicListCell_Previews()
        case .bapAdView:
            return BapAdView_Previews()
        case .savedSearches:
            return SavedSearchesView_Previews()
        }
    }
}

// MARK: - PreviewProvider conformances

extension ButtonStyleUsageDemoView_Previews: Demoable {}
extension SettingsView_Previews: Demoable {}
extension BasicListCell_Previews: Demoable {}
extension BapAdView_Previews: Demoable {}
extension SavedSearchesView_Previews: Demoable {}
