import UIKit
import FinniversKit

extension MotorSidebar {
    public struct ViewModel {
        public let mainSections: [Section]
        public let secondary: Section?

        public init(mainSections: [Section], secondary: Section? = nil) {
            self.mainSections = mainSections
            self.secondary = secondary
        }
    }
}

extension MotorSidebar.ViewModel {
    public struct Section {
        public let isExpandable: Bool
        public let isExpanded: Bool?
        public let ribbon: Ribbon?
        public let price: Price?
        public let header: Header?
        public let content: [Body]
        public let bulletPoints: [String]
        public let buttons: [Button]

        public init(
            isExpandable: Bool,
            isExpanded: Bool? = nil,
            ribbon: Ribbon? = nil,
            price: Price? = nil,
            header: Header? = nil,
            content: [Body],
            bulletPoints: [String] = [],
            buttons: [Button] = []
        ) {
            self.isExpandable = isExpandable
            self.isExpanded = isExpanded
            self.ribbon = ribbon
            self.price = price
            self.header = header
            self.content = content
            self.bulletPoints = bulletPoints
            self.buttons = buttons
        }
    }

    public struct Ribbon {
        public let title: String
        public let backgroundColor: UIColor

        public init(title: String, backgroundColor: UIColor) {
            self.title = title
            self.backgroundColor = backgroundColor
        }
    }

    public struct Price {
        public let title: String
        public let value: String

        public init(title: String, value: String) {
            self.title = title
            self.value = value
        }
    }

    public struct Header {
        public let title: String
        public let icon: UIImage

        public init(title: String, icon: UIImage) {
            self.title = title
            self.icon = icon
        }
    }

    public struct Body {
        public let text: String
        public let inlineImage: InlineImage?

        public init(text: String, inlineImage: InlineImage? = nil) {
            self.text = text
            self.inlineImage = inlineImage
        }

        public struct InlineImage {
            public let image: UIImage

            // If you have an image with a baseline that *is not* the bottom of the image (i.e. an image with text),
            // set this value equal to the amount of overflowing pixels from the bottom.
            public let baselineOffset: CGFloat

            public init(image: UIImage, baselineOffset: CGFloat = 0) {
                self.image = image
                self.baselineOffset = baselineOffset
            }
        }
    }

    public struct Button {
        public let kind: Kind
        public let identifier: String?
        public let text: String
        public let urlString: String?
        public let isExternal: Bool

        public init(kind: Kind, identifier: String?, text: String, urlString: String?, isExternal: Bool) {
            self.kind = kind
            self.identifier = identifier
            self.text = text
            self.urlString = urlString
            self.isExternal = isExternal
        }

        public enum Kind {
            case primary
            case secondary
            case link

            var buttonStyle: FinniversKit.Button.Style {
                switch self {
                case .link:
                    return .flat
                case .primary:
                    return .callToAction
                case .secondary:
                    return .default
                }
            }
        }
    }
}
