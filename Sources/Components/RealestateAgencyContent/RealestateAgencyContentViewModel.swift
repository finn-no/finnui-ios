import UIKit

public struct RealestateAgencyContentViewModel {
    public let logoUrl: String
    public let articles: [ArticleItem]

    public init(logoUrl: String, articles: [ArticleItem]) {
        self.logoUrl = logoUrl
        self.articles = articles
    }
}

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
