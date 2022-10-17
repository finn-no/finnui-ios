import UIKit

extension RealestateSoldStateModel {
    public struct Style {
        public let headingStyle: HeadingStyle
        public let profileStyle: CompanyProfile.ProfileStyle
        public let actionButtonStyle: CompanyProfile.ButtonStyle

        public init(
            headingStyle: HeadingStyle,
            profileStyle: CompanyProfile.ProfileStyle,
            actionButtonStyle: CompanyProfile.ButtonStyle
        ) {
            self.headingStyle = headingStyle
            self.profileStyle = profileStyle
            self.actionButtonStyle = actionButtonStyle
        }
    }

    public struct HeadingStyle {
        public let backgroundColor: UIColor
        public let logoBackgroundColor: UIColor

        public init(backgroundColor: UIColor, logoBackgroundColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.logoBackgroundColor = logoBackgroundColor
        }
    }
}

