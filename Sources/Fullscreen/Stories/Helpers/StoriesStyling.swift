import Foundation
import UIKit
import FinniversKit

struct StoriesStyling {
    static let defaultImageBackgroundColor: UIColor = .storyDefaultBackgrondColor
    static let iconTintColor: UIColor = .milk
    static let primaryTextColor: UIColor = .milk
    static let progressBarColor: UIColor = .milk

    static let storyTitleStyle: Label.Style = .captionStrong
    static let slideTitleStyle: Label.Style = .title3Strong
    static let slideDetailStyle: Label.Style = .detail
    static let priceLabelStyle: Label.Style = .captionStrong
    static let priceLabelColor: UIColor = .textTertiary

    static let openAdButtonStyle: Button.Style = .callToAction
    static let openAdButtonSize: Button.Size = .normal

    // Styling for feedback module
    static let feedbackBackgroundColor: UIColor = .primaryBlue
    static let feedbackTitleStyle: Label.Style = .title2
    static let feedbackDisclaimerStyle: Label.Style = .detail
    static let feedbackSuccessLabelStyle: Label.Style = .title1
}

private extension UIColor {
    class var storyDefaultBackgrondColor: UIColor {
        UIColor(hex: "#1B1B24")
    }
}
