import Foundation

public class UniqueHashableItem: Hashable {
    private let identifier = UUID()

    public static func == (lhs: UniqueHashableItem, rhs: UniqueHashableItem) -> Bool {
        lhs.identifier == rhs.identifier
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
}
