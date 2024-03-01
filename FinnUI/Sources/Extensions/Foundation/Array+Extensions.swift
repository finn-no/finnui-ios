//
//  Copyright © FINN.no AS. All rights reserved.
//

import Foundation

extension Array where Array.Element: ExpressibleByNilLiteral {
    subscript(safe index: Index) -> Element {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Hashable {
    /// Return an array with any duplicates removed
    func unique() -> [Element] {
        var uniqueElements = Set(self)
        return compactMap { uniqueElements.remove($0) }
    }
}
