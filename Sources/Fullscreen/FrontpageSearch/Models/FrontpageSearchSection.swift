import Foundation

/*
public enum SearchSuggestionSection: Hashable {
    case group(SearchSuggestionGroup)
    case viewMoreResults(title: String)
    case locationPermission(title: String)
}*/

public enum FrontpageSearchSection: Hashable {
    case group(FrontpageSearchGroup)
    case viewMoreResults(FrontpageSearchGroupItem)
    case locationPermission(FrontpageSearchGroupItem)
}
