import UIKit

extension CompanyProfile {
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
