import UIKit
import FinniversKit

extension Button {
    static func create(for article: RealestateAgencyContentViewModel.ArticleItem) -> Button {
        let style: Button.Style = {
            switch article.buttonKind {
            case .highlighted:
                return .callToAction
            case .normal:
                return .flat
            }
        }()

        let button = Button(style: style, size: .normal, withAutoLayout: true)
        button.setTitle(article.buttonTitle, for: .normal)
        return button
    }
}
