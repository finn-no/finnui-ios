import Foundation

public enum SearchSuggestionSection: Hashable {
    case group(SearchSuggestionGroup)
    case viewMoreResults(title: String)
    case locationPermission(title: String)
}
