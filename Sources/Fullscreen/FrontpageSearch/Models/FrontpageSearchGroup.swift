import Foundation
public class FrontpageSearchGroup: UniqueHashableItem {
    public let title: String
    public let items: [FrontpageSearchGroupItem]
    public let displayType: SearchDisplayType?

    public init(title: String, items: [FrontpageSearchGroupItem], groupType: SearchDisplayType? = .regular) {
        self.title = title
        self.items = items
        self.displayType = groupType
    }
}

public enum SearchDisplayType {
    case circularImage
    case external
    case image
    case regular
}
