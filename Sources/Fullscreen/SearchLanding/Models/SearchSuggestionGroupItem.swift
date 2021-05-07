import Foundation

public struct SearchSuggestionGroupItem {
    public enum Style {
        case regular
        case bold
        case highlighted
    }

    public let title: String
    public let detail: String?
    public let style: Style

    public init(title: String, detail: String?, style: Style = .bold) {
        self.title = title
        self.detail = detail
        self.style = style
    }
}
