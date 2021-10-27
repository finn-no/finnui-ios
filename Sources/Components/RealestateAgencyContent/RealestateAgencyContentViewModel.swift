import UIKit

public struct RealestateAgencyContentViewModel {
    public let logoUrl: String
    public let articles: [ArticleItem]
    public let colors: Colors

    public init(logoUrl: String, articles: [ArticleItem], colors: Colors) {
        self.logoUrl = logoUrl
        self.articles = articles
        self.colors = colors
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

// MARK: - Colors

extension RealestateAgencyContentViewModel {
    public struct Colors {
        public let main: Group
        public let actionButton: Group

        public init(main: Group, actionButton: Group) {
            self.main = main
            self.actionButton = actionButton
        }

        public struct Group {
            public let text: UIColor
            public let background: UIColor

            public init(text: UIColor, background: UIColor) {
                self.text = text
                self.background = background
            }
        }
    }
}
