import UIKit

public struct AlertModel<T> {
    public struct ActionModel<T> {
        public var title: String?
        public var style: UIAlertAction.Style
        public var value: T

        public init(title: String? = nil, style: UIAlertAction.Style, value: T) {
            self.title = title
            self.style = style
            self.value = value
        }
    }

    public var actionModels = [ActionModel<T>]()
    public var title: String?
    public var message: String?
    public var prefferedStyle: UIAlertController.Style

    public init(actionModels: [AlertModel<T>.ActionModel<T>] = [ActionModel<T>](), title: String? = nil, message: String? = nil, prefferedStyle: UIAlertController.Style) {
        self.actionModels = actionModels
        self.title = title
        self.message = message
        self.prefferedStyle = prefferedStyle
    }
}
