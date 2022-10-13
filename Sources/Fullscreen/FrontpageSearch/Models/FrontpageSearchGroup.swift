import Foundation

/*
public class SearchSuggestionGroup: UniqueHashableItem {
    public let title: String
    public let items: [SearchSuggestionGroupItem]
    public let groupType: SearchSuggestionGroupType?

    public init(title: String, items: [SearchSuggestionGroupItem], groupType: SearchSuggestionGroupType? = .regular) {
        self.title = title
        self.items = items
        self.groupType = groupType
    }
}*/
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
    case image
    case circularImage
    case regular
}
