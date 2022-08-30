public protocol FiksFerdigContactSellerViewModelDelegate: AnyObject {
    func fiksFerdigContactSellerViewModelDidRequestContactSeller()
}

public struct FiksFerdigContactSellerViewModel {
    public let message: String
    public let buttonTitle: String

    public weak var delegate: FiksFerdigContactSellerViewModelDelegate?

    public init(message: String, buttonTitle: String) {
        self.message = message
        self.buttonTitle = buttonTitle
    }

    func contactSeller() {
        delegate?.fiksFerdigContactSellerViewModelDidRequestContactSeller()
    }
}
