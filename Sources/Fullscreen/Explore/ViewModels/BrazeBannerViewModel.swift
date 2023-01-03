import FinniversKit

class BrazeBannerViewModel: UniqueHashableItem {
    let brazePromo: BrazePromotionView

    public init(brazePromo: BrazePromotionView) {
        self.brazePromo = brazePromo
    }
}
