import FinnUI

struct WishlistButtonData: WishlistButtonViewModel {
    var title: String {
        return isWishlisted ? "Lagt til i ønskeliste" : "Legg til i ønskeliste"
    }

    var isWishlisted: Bool
}
