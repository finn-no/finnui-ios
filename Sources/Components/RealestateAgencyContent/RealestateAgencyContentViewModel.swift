import UIKit

public struct RealestateAgencyContentViewModel {
    public let logoUrl: String
    public let articles: [ArticleItem]
    public let style: CompanyProfile.ProfileStyle

    public init(logoUrl: String, articles: [ArticleItem], style: CompanyProfile.ProfileStyle) {
        self.logoUrl = logoUrl
        self.articles = articles
        self.style = style
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
        public let articleUrl: String

        public init(title: String, body: String, imageUrl: String, buttonTitle: String, buttonKind: ButtonKind, articleUrl: String) {
            self.title = title
            self.body = body
            self.imageUrl = imageUrl
            self.buttonTitle = buttonTitle
            self.buttonKind = buttonKind
            self.articleUrl = articleUrl
        }
    }
}
