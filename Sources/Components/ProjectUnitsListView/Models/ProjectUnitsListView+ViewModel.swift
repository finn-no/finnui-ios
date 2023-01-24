import Foundation

extension ProjectUnitsListView {
    public struct ViewModel {
        public let titles: Titles
        public let columnHeadings: ColumnHeadings
        public let units: [UnitItem]

        public init(titles: Titles, columnHeadings: ColumnHeadings, units: [UnitItem]) {
            self.titles = titles
            self.columnHeadings = columnHeadings
            self.units = units
        }
    }
}
