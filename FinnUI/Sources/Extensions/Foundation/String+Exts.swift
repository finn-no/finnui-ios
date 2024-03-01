import UIKit

public extension String {
    func attributedHTMLString(font: UIFont, style: [String: String] = [:], textColor: UIColor) -> NSAttributedString {
        var styledText = self
        for (styleIdentifier, styleItem) in style {
            styledText = styledText.replacingOccurrences(of: styleIdentifier, with: styleItem)
        }
        let htmlTemplate = "<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize); color: \(textColor.hexString)\">\(styledText)</span>"

        guard
            let data = htmlTemplate.data(using: .utf8),
            let attrStr = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        else {
            return NSAttributedString(string: self)
        }

        return attrStr
    }
}
