import Foundation

public enum SearchSuggestionSection: Hashable {
    case group(SearchSuggestionGroup)
    case viewMoreResults(title: String)
    case locationPermission(title: String)
}

public enum SearchLandingSection: Hashable {
    case group(SearchLandingGroup)
    case viewMoreResults(title: String)
    case locationPermission(title: String)
}
