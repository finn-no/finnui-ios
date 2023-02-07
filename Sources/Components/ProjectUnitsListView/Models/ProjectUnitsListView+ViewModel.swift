import Foundation

extension ProjectUnitsListView {
    public struct ViewModel {
        public let titles: Titles
        public let columnHeadings: ColumnHeadings

        public init(titles: Titles, columnHeadings: ColumnHeadings) {
            self.titles = titles
            self.columnHeadings = columnHeadings
        }
    }
}
