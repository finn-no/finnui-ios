import UIKit

extension RealestateSoldStateModel {
    public struct Styling {
        public let heading: HeadingStyle
        public let profileBox: ProfileBoxStyle
        public let ctaButton: ButtonStyle

        public init(heading: HeadingStyle, profileBox: ProfileBoxStyle, ctaButton: ButtonStyle) {
            self.heading = heading
            self.profileBox = profileBox
            self.ctaButton = ctaButton
        }
    }
}

extension RealestateSoldStateModel.Styling {
    public struct HeadingStyle {
        public let backgroundColor: UIColor
        public let logoBackgroundColor: UIColor

        public init(backgroundColor: UIColor, logoBackgroundColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.logoBackgroundColor = logoBackgroundColor
        }
    }

    public struct ProfileBoxStyle {
        public let actionButton: ButtonStyle
        public let textColor: UIColor
        public let backgroundColor: UIColor
        public let logoBackgroundColor: UIColor

        public init(actionButton: ButtonStyle, textColor: UIColor, backgroundColor: UIColor, logoBackgroundColor: UIColor) {
            self.actionButton = actionButton
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.logoBackgroundColor = logoBackgroundColor
        }
    }

    public struct ButtonStyle {
        public let textColor: UIColor
        public let backgroundColor: UIColor
        public let backgroundActiveColor: UIColor
        public let borderColor: UIColor

        public init(textColor: UIColor, backgroundColor: UIColor, backgroundActiveColor: UIColor, borderColor: UIColor) {
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.backgroundActiveColor = backgroundActiveColor
            self.borderColor = borderColor
        }
    }
}

