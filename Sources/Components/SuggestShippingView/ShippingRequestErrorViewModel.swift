public protocol SuggestShippingErrorViewModelButtonHandler {
    func didTapButton()
}

public struct ShippingRequestErrorViewModel {
    let title: String
    let message: String
    let buttonTitle: String

    private let buttonHandler: SuggestShippingErrorViewModelButtonHandler

    public init(title: String, message: String, buttonTitle: String, buttonHandler: SuggestShippingErrorViewModelButtonHandler) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonHandler = buttonHandler
    }

    public func openInfoURL() {
        buttonHandler.didTapButton()
    }
}
