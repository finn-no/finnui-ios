import Combine
import UIKit

public protocol SuggestShippingViewModelDelegate: AnyObject {
    func didRequestShipping(suggestShippingViewModel: SuggestShippingViewModel)
}

public class SuggestShippingViewModel {
    @Published public var isProcessing = false

    private(set) public var title: String
    private(set) public var message: String
    private(set) public var buttonTitle: String
    private(set) public var alertModel: AlertModel<Bool>

    private let adId: String
    public weak var delegate: SuggestShippingViewModelDelegate?

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
        delegate?.didRequestShipping(suggestShippingViewModel: self)
    }
}
