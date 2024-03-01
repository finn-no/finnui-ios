import Foundation

extension ProjectUnitsListView {
    public struct ColumnHeadings {
        public let name: String
        public let floor: String
        public let bedrooms: String
        public let area: String
        public let totalPrice: String

        public init(
            name: String,
            floor: String,
            bedrooms: String,
            area: String,
            totalPrice: String
        ) {
            self.name = name
            self.floor = floor
            self.bedrooms = bedrooms
            self.area = area
            self.totalPrice = totalPrice
        }

        func title(for column: Column) -> String {
            switch column {
            case .area: return area
            case .bedrooms: return bedrooms
            case .floor: return floor
            case .name: return name
            case .totalPrice: return totalPrice
            }
        }
    }
}
