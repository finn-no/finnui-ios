import UIKit

extension RealestateSoldStateModel {
    public struct Styling {
        public let textColor: UIColor
        public let logoBackgroundColor: UIColor
        public let backgroundColor: UIColor
        public let ctaButtonStyle: ButtonStyle
        public let secondayButtonStyle: ButtonStyle

        public init(
            textColor: UIColor,
            logoBackgroundColor: UIColor,
            backgroundColor: UIColor,
            ctaButtonStyle: ButtonStyle,
            secondayButtonStyle: ButtonStyle
        ) {
            self.textColor = textColor
            self.logoBackgroundColor = logoBackgroundColor
            self.backgroundColor = backgroundColor
            self.ctaButtonStyle = ctaButtonStyle
            self.secondayButtonStyle = secondayButtonStyle
        }
    }
}

extension RealestateSoldStateModel.Styling {
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

