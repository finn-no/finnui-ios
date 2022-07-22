import Combine

public protocol SuggestShippingDelegate: AnyObject {
    func didAskForConfirmation(with alertModel: AlertModel<Bool>) async -> Bool
    func didRequestShipping(forAdId adId: String)
}

public class SuggestShippingViewModel {
    @Published private(set) public var isProcessing = false

    private(set) public var title: String
    private(set) public var message: String
    private(set) public var buttonTitle: String
    private(set) public var alertModel: AlertModel<Bool>

    private let adId: String
    public weak var delegate: SuggestShippingDelegate?

    public init(
        title: String,
        message: String,
        buttonTitle: String,
        adId: String,
        alertModel: AlertModel<Bool>
    ) {
        self.adId = adId
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.alertModel = alertModel
    }

    public func suggestShipping() {
        Task {
            guard
                await delegate?.didAskForConfirmation(with: alertModel) ?? false
            else {
                return
            }

            isProcessing = true
            delegate?.didRequestShipping(forAdId: adId)
        }
    }
}

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

