public final class FiksFerdigInfoViewModel {
    public let serviceInfoViewModel: FiksFerdigServiceInfoViewModel
    public let shippingInfoViewModel: FiksFerdigShippingInfoViewModel?
    public let safePaymentInfoViewModel: FiksFerdigSafePaymentInfoViewModel

    public init(
        serviceInfoViewModel: FiksFerdigServiceInfoViewModel,
        shippingInfoViewModel: FiksFerdigShippingInfoViewModel?,
        safePaymentInfoViewModel: FiksFerdigSafePaymentInfoViewModel
    ) {
        self.serviceInfoViewModel = serviceInfoViewModel
        self.shippingInfoViewModel = shippingInfoViewModel
        self.safePaymentInfoViewModel = safePaymentInfoViewModel
    }
}
