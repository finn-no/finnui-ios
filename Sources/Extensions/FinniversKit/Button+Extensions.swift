import UIKit
import FinniversKit

extension Button {
    static func create(
        for article: RealestateAgencyContentViewModel.ArticleItem,
        textColor: UIColor,
        backgroundColor: UIColor
    ) -> Button {
        let style: Button.Style = {
            switch article.buttonKind {
            case .highlighted:
                return .callToAction.overrideStyle(bodyColor: backgroundColor, textColor: textColor)
            case .normal:
                return .flat.overrideStyle(textColor: backgroundColor)
            }
        }()

        let button = Button(style: style, size: .normal, withAutoLayout: true)
        button.setTitle(article.buttonTitle, for: .normal)
        return button
    }
}
