public protocol SuggestShippingErrorViewModelDelegate: AnyObject {
    func suggestShippingErrorViewModelDidTapOpenInfoButton()
}

public struct ShippingRequestErrorViewModel {
    let title: String
    let message: String
    let buttonTitle: String

    private weak var delegate: SuggestShippingErrorViewModelDelegate?

    public init(
        title: String,
        message: String,
        buttonTitle: String,
        delegate: SuggestShippingErrorViewModelDelegate) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.delegate = delegate
    }

    public func openInfoURL() {
        delegate?.suggestShippingErrorViewModelDidTapOpenInfoButton()
    }
}
