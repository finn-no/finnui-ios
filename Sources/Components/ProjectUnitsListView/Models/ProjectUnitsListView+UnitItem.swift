import Foundation

extension ProjectUnitsListView {
    public struct UnitItem {
        public let identifier: Int
        public let name: String
        public let floor: String
        public let bedrooms: String
        public let area: String
        public let totalPrice: String
        public let isSold: Bool

        public init(
            identifier: Int,
            name: String,
            floor: String,
            bedrooms: String,
            area: String,
            totalPrice: String,
            isSold: Bool
        ) {
            self.identifier = identifier
            self.name = name
            self.floor = floor
            self.bedrooms = bedrooms
            self.area = area
            self.totalPrice = totalPrice
            self.isSold = isSold
        }

        func value(for column: Column) -> String {
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
