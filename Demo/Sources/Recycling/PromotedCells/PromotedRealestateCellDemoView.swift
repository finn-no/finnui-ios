import FinnUI
import FinniversKit
import MapKit

class PromotedRealestateCellDemoView: UIView, Tweakable {

    private var realestateView: PromotedRealestateCellView?

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Single image", action: { [weak self] in
            self?.configure(with: .default, promoKind: .singleImage)
        }),
        TweakingOption(title: "Two images and map", action: { [weak self] in
            self?.configure(with: .default, promoKind: .imagesAndMap)
        }),
        TweakingOption(title: "Two images and map", description: "Mostly nil values", action: { [weak self] in
            self?.configure(with: .mostlyEmpty, promoKind: .imagesAndMap)
        })
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action?()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func configure(with viewModel: PromotedRealestateCellViewModel, promoKind: PromotedRealestateCellView.PromoKind) {
        realestateView?.removeFromSuperview()

        let realestateView = PromotedRealestateCellView(
            viewModel: viewModel,
            promoKind: promoKind,
            remoteImageViewDataSource: self,
            withAutoLayout: true
        )
        realestateView.delegate = self
        realestateView.configure(mapTileOverlay: FINNMapTileOverlay())
        addSubview(realestateView)

        NSLayoutConstraint.activate([
            realestateView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            realestateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            realestateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
        self.realestateView = realestateView
    }
}

// MARK: - PromotedRealestateCellViewDelegate

extension PromotedRealestateCellDemoView: PromotedRealestateCellViewDelegate {
    func promotedRealestateCellViewDidToggleFavoriteState(_ view: PromotedRealestateCellView, button: UIButton) {
        view.configure(isFavorited: !view.isFavorited)
    }
}

// MARK: - RemoteImageViewDataSource

extension PromotedRealestateCellDemoView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}

    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }
}

// MARK: - Private extensions / types

private extension PromotedRealestateCellViewModel {
    static var `default`: PromotedRealestateCellViewModel {
        PromotedRealestateCellViewModel(
            title: "Arealsmart studioleilighet med separat kjøkken - smart alkoveløsning - God standard - V.v & fyring ink - Originale gulv",
            address: "Sentrumsgate 12, 0001 Oslo",
            primaryAttributes: ["100m\u{00B2}", "Totalpris: 5 000 000 kr"],
            secondaryAttributes: ["Eier (selveier)", "Leilighet", "4 soverom"],
            totalPriceText: "Totalpris: 5 628 420 kr",
            viewingText: "Visning - 16. mai, kl 17:00",
            primaryImageUrl: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
            secondaryImageUrl: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
            realtorName: "FINN Eiendom",
            realtorImageUrl: "https://kommunikasjon.ntb.no/data/images/00171/daaffdf6-fb0e-4e74-9b6b-7f973dbfa6a3.png",
            highlightColor: UIColor(hex: "#0063FB"),
            mapCoordinates: CLLocationCoordinate2D(latitude: 59.9137496948242, longitude: 10.7438659667969)
        )
    }

    static var mostlyEmpty: PromotedRealestateCellViewModel {
        PromotedRealestateCellViewModel(
            title: nil,
            address: nil,
            primaryAttributes: nil,
            secondaryAttributes: nil,
            totalPriceText: nil,
            viewingText: nil,
            primaryImageUrl: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
            secondaryImageUrl: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
            realtorName: nil,
            realtorImageUrl: "https://kommunikasjon.ntb.no/data/images/00171/daaffdf6-fb0e-4e74-9b6b-7f973dbfa6a3.png",
            highlightColor: UIColor(hex: "#0063FB"),
            mapCoordinates: CLLocationCoordinate2D(latitude: 59.9137496948242, longitude: 10.7438659667969)
        )
    }
}

private class FINNMapTileOverlay: MKTileOverlay {
    init() {
        let templateUrl = "http://maptiles.finncdn.no/tileService/1.0.3/normap/{z}/{x}/{y}"
        super.init(urlTemplate: templateUrl)
        canReplaceMapContent = true
    }

    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let tileUrl = super.url(forTilePath: path)

        if path.contentScaleFactor > 1 {
            var retinaComponents = URLComponents(url: tileUrl, resolvingAgainstBaseURL: true)
            retinaComponents?.path.append("@2x")
            if let retinaTileUrl = retinaComponents?.url {
                tileSize = CGSize(width: 512, height: 512)
                return retinaTileUrl
            }
        }

        tileSize = CGSize(width: 256, height: 256)
        return tileUrl
    }
}
