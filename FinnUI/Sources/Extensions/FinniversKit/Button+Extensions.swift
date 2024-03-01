import UIKit
import FinniversKit

extension Button {
    static func create(
        for article: RealestateAgencyContentViewModel.ArticleItem,
        profileStyle: CompanyProfile.ProfileStyle
    ) -> Button {
        let highlightedImageColor: UIColor
        let buttonStyle: Button.Style

        switch article.buttonKind {
        case .highlighted:
            highlightedImageColor = profileStyle.actionButtonStyle?.textColor ?? profileStyle.textColor
            buttonStyle = .callToAction.override(using: profileStyle.actionButtonStyle)
        case .normal:
            highlightedImageColor = profileStyle.textColor.withAlphaComponent(0.7)
            buttonStyle = .flat.overrideStyle(
                textColor: profileStyle.textColor,
                highlightedTextColor: highlightedImageColor
            )
        }

        let button = Button(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.setTitle(article.buttonTitle, for: .normal)
        button.tintColor = button.currentTitleColor
        button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.lineBreakMode = .byWordWrapping

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
