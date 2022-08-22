import Foundation

public struct SearchSuggestionGroup: Hashable {
    public let title: String
    public let items: [SearchSuggestionGroupItem]
    public let groupType: SearchSuggestionGroupType

    public init(title: String, items: [SearchSuggestionGroupItem], groupType: SearchSuggestionGroupType) {
        self.title = title
        self.items = items
        self.groupType = groupType
    }
}


public enum SearchSuggestionGroupType {
    case image
    case circularImage
    case regular
}


public struct SearchLandingGroup: Hashable {
    public let title: String
    public let items: [SearchLandingGroupItem]
    public let groupType: SearchSuggestionGroupType

    public init(title: String, items: [SearchLandingGroupItem], groupType: SearchSuggestionGroupType) {
        self.title = title
        self.items = items
        self.groupType = groupType
    }
}
