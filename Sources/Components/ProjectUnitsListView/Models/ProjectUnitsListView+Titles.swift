import Foundation

extension ProjectUnitsListView {
    public struct Titles {
        public let title: String
        public let sortingTitle: String
        public let hideSoldUnitsButtonTitle: String
        public let showSoldUnitsButtonTitle: String

        public init(title: String, sortingTitle: String, hideSoldUnitsButtonTitle: String, showSoldUnitsButtonTitle: String) {
            self.title = title
            self.sortingTitle = sortingTitle
            self.hideSoldUnitsButtonTitle = hideSoldUnitsButtonTitle
            self.showSoldUnitsButtonTitle = showSoldUnitsButtonTitle
        }
    }
}
