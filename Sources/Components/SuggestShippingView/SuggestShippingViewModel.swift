import Combine

public protocol SuggestShippingDelegate: AnyObject {
    func didRequestShipping(forAdId adId: String)
}

public class SuggestShippingViewModel {
    @Published private(set) public var isProcessing = false

    private(set) public var title: String
    private(set) public var message: String
    private(set) public var buttonTitle: String

    private let adId: String
    public weak var delegate: SuggestShippingDelegate?

    public init(
        title: String,
        message: String,
        buttonTitle: String,
        adId: String
    ) {
        self.adId = adId
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
    }

    public func suggestShipping() {
        isProcessing = true
        delegate?.didRequestShipping(forAdId: adId)
    }
}
