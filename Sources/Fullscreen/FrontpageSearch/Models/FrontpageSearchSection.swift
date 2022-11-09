import Foundation

public enum FrontpageSearchSection: Hashable {
    case group(FrontpageSearchGroup)
    case viewMoreResults(FrontpageSearchGroupItem)
    case locationPermission(FrontpageSearchGroupItem)
}
