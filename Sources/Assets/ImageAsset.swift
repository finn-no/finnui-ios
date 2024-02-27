//
//  Copyright © FINN.no AS.
//

// Generated by generate_image_assets_symbols as a "Run Script" Build Phase
// WARNING: This file is autogenerated, do not modify by hand

import UIKit

private class BundleHelper {
}

extension UIImage {
    convenience init(named imageAsset: ImageAsset) {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BundleHelper.self)
        #endif
        self.init(named: imageAsset.rawValue, in: bundle, compatibleWith: nil)!
    }

    @objc class func assetNamed(_ assetName: String) -> UIImage {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BundleHelper.self)
        #endif
        return UIImage(named: assetName, in: bundle, compatibleWith: nil)!
    }
}

//swiftlint:disable superfluous_disable_command
//swiftlint:disable type_body_length
enum ImageAsset: String {
    case alphabeticalSortingAscending
    case arrowUp
    case backgroundFigureLeft
    case backgroundFigureRight
    case backgroundFigureTop
    case balloon0
    case balloon2
    case balloon2Red
    case balloon3
    case blinkRocket
    case checkMark
    case chevronDown
    case chevronUp
    case close
    case emptyPersonalNotificationsIcon
    case emptySavedSearchNotificationsIcon
    case externalLink
    case favoriteActive
    case favoriteDefault
    case favorited
    case favoritesSortAdStatus
    case favoritesSortDistance
    case favoritesSortLastAdded
    case finnLogoSimple
    case heartMini
    case lock
    case mapPin
    case notFavorited
    case overflowMenuHorizontal
    case pin
    case plus
    case profile
    case remove
    case repair
    case republish
    case schibstedFooter
    case searchBig
    case searchSmall
    case share
    case snowflake
    case spark
    case splashLetters1
    case splashLetters2
    case splashLetters3
    case splashLetters4
    case splashLogo
    case storyPlaceholder
    case tagMini
    case trashcan
    case videoChat
    case webview

    static var imageNames: [ImageAsset] {
        return [
            .alphabeticalSortingAscending,
            .arrowUp,
            .backgroundFigureLeft,
            .backgroundFigureRight,
            .backgroundFigureTop,
            .balloon0,
            .balloon2,
            .balloon2Red,
            .balloon3,
            .blinkRocket,
            .checkMark,
            .chevronDown,
            .chevronUp,
            .close,
            .emptyPersonalNotificationsIcon,
            .emptySavedSearchNotificationsIcon,
            .externalLink,
            .favoriteActive,
            .favoriteDefault,
            .favorited,
            .favoritesSortAdStatus,
            .favoritesSortDistance,
            .favoritesSortLastAdded,
            .finnLogoSimple,
            .heartMini,
            .lock,
            .mapPin,
            .notFavorited,
            .overflowMenuHorizontal,
            .pin,
            .plus,
            .profile,
            .remove,
            .repair,
            .republish,
            .schibstedFooter,
            .searchBig,
            .searchSmall,
            .share,
            .snowflake,
            .spark,
            .splashLetters1,
            .splashLetters2,
            .splashLetters3,
            .splashLetters4,
            .splashLogo,
            .storyPlaceholder,
            .tagMini,
            .trashcan,
            .videoChat,
            .webview,
    ]
  }
}
