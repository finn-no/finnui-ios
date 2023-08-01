public protocol FiksFerdigInfoViewModelDelegate: AnyObject {
    func didChangeSidebarHeight()
}

public final class FiksFerdigInfoViewModel {
    public let serviceInfoViewModel: FiksFerdigServiceInfoViewModel
    public let shippingInfoViewModel: FiksFerdigShippingInfoViewModel?
    public let safePaymentInfoViewModel: FiksFerdigSafePaymentInfoViewModel

    public weak var delegate: FiksFerdigInfoViewModelDelegate?

    public init(serviceInfoViewModel: FiksFerdigServiceInfoViewModel, shippingInfoViewModel: FiksFerdigShippingInfoViewModel?, safePaymentInfoViewModel: FiksFerdigSafePaymentInfoViewModel) {
        self.serviceInfoViewModel = serviceInfoViewModel
        self.shippingInfoViewModel = shippingInfoViewModel
        self.safePaymentInfoViewModel = safePaymentInfoViewModel

        shippingInfoViewModel?.headerViewModel.delegate = self
    }
}

extension FiksFerdigInfoViewModel: FiksFerdigAccordionViewModelDelegate {
    public func didChangeExpandedState(isExpanded: Bool) {
        delegate?.didChangeSidebarHeight()
    }
}
