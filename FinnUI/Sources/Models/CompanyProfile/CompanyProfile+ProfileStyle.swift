import UIKit

extension CompanyProfile {
    public struct ProfileStyle {
        public let textColor: UIColor
        public let backgroundColor: UIColor
        public let logoBackgroundColor: UIColor
        public let actionButtonStyle: CompanyProfile.ButtonStyle?

        public init(
            textColor: UIColor,
            backgroundColor: UIColor,
            logoBackgroundColor: UIColor,
            actionButtonStyle: CompanyProfile.ButtonStyle?
        ) {
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.logoBackgroundColor = logoBackgroundColor
            self.actionButtonStyle = actionButtonStyle
        }
    }
}
