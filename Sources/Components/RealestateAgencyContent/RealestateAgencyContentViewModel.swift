import UIKit

public struct RealestateAgencyContentViewModel {
    public let logoUrl: String
    public let articles: [ArticleItem]
    public let styling: Styling

    public init(logoUrl: String, articles: [ArticleItem], styling: Styling) {
        self.logoUrl = logoUrl
        self.articles = articles
        self.styling = styling
    }
}

// MARK: - ArticleItem

extension RealestateAgencyContentViewModel {
    public struct ArticleItem {
        public enum ButtonKind {
            case highlighted
            case normal
        }

        public let title: String
        public let body: String
        public let imageUrl: String
        public let buttonTitle: String
        public let buttonKind: ButtonKind

        public init(title: String, body: String, imageUrl: String, buttonTitle: String, buttonKind: ButtonKind) {
            self.title = title
            self.body = body
            self.imageUrl = imageUrl
            self.buttonTitle = buttonTitle
            self.buttonKind = buttonKind
        }
    }
}

// MARK: - Styling

extension RealestateAgencyContentViewModel {
    public struct Styling {
        public let textColor: UIColor
        public let backgroundColor: UIColor
        public let logoBackgroundColor: UIColor
        public let actionButton: ButtonStyle

        public init(textColor: UIColor, backgroundColor: UIColor, logoBackgroundColor: UIColor, actionButton: ButtonStyle) {
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.logoBackgroundColor = logoBackgroundColor
            self.actionButton = actionButton
        }
    }
}

// MARK: - ButtonStyle

extension RealestateAgencyContentViewModel.Styling {
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
