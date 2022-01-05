import UIKit
import FinniversKit

extension Button {
    static func create(
        for article: RealestateAgencyContentViewModel.ArticleItem,
        styling: RealestateAgencyContentViewModel.Styling
    ) -> Button {
        let highlightedImageColor: UIColor
        let style: Button.Style

        switch article.buttonKind {
        case .highlighted:
            highlightedImageColor = styling.actionButton.textColor
            style = .callToAction.overrideStyle(
                bodyColor: styling.actionButton.backgroundColor,
                borderColor: styling.actionButton.borderColor,
                textColor: styling.actionButton.textColor,
                highlightedBodyColor: styling.actionButton.backgroundActiveColor
            )
        case .normal:
            highlightedImageColor = styling.textColor.withAlphaComponent(0.7)
            style = .flat.overrideStyle(
                textColor: styling.textColor,
                highlightedTextColor: highlightedImageColor
            )
        }

        let button = Button(style: style, size: .normal, withAutoLayout: true)
        button.setTitle(article.buttonTitle, for: .normal)
        button.tintColor = button.currentTitleColor
        button.semanticContentAttribute = .forceRightToLeft

        let defaultImage = UIImage(named: .externalLink).withRenderingMode(.alwaysTemplate)
        button.setImage(defaultImage, for: .normal)

        let highlightImage = defaultImage.withTintColor(highlightedImageColor, renderingMode: .alwaysOriginal)
        button.setImage(highlightImage, for: .highlighted)

        switch article.buttonKind {
        case .highlighted:
            button.setInsets(
                contentPadding: UIEdgeInsets(all: .spacingS),
                imageTitlePadding: .spacingS
            )
        case .normal:
            button.contentHorizontalAlignment = .left
            button.setInsets(
                contentPadding: UIEdgeInsets(vertical: .spacingS, horizontal: 0),
                imageTitlePadding: .spacingS
            )
        }

        return button
    }

    /// Credit to Noah Gilmore (https://noahgilmore.com/blog/uibutton-padding).
    func setInsets(contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        switch semanticContentAttribute {
        case .forceRightToLeft:
            contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left + imageTitlePadding,
                bottom: contentPadding.bottom,
                right: contentPadding.right
            )
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageTitlePadding,
                bottom: 0,
                right: imageTitlePadding
            )
        default:
            contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left,
                bottom: contentPadding.bottom,
                right: contentPadding.right + imageTitlePadding
            )
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: imageTitlePadding,
                bottom: 0,
                right: -imageTitlePadding
            )
        }
    }
}
