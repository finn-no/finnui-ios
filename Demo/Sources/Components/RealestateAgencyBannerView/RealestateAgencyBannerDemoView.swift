import UIKit
import FinniversKit
import FinnUI
import DemoKit

class RealestateAgencyBannerDemoView: UIView, Demoable {

    // MARK: - Private properties

    private lazy var bannerView = RealestateAgencyBannerView(
        viewModel: .default,
        delegate: self,
        remoteImageViewDataSource: self,
        withAutoLayout: true
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bannerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            bannerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

// MARK: - RealestateAgencyBannerViewDelegate

extension RealestateAgencyBannerDemoView: RealestateAgencyBannerViewDelegate {
    func realestateAgencyBannerViewDidSelectScrollButton(_ view: RealestateAgencyBannerView) {
        print("👉 Did tap scroll button.")
    }
}

// MARK: - RemoteImageViewDataSource

extension RealestateAgencyBannerDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping (UIImage?) -> Void) {
        if imagePath == "FINN-LOGO" {
            completion(UIImage(named: .finnLogoLarge))
            return
        }

        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

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

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
    }
}

// MARK: - Private extensions

private extension RealestateAgencyBannerViewModel {
    static var `default`: Self {
        RealestateAgencyBannerViewModel(
            logoUrl: "FINN-LOGO",
            buttonTitle: "Se våre artikler",
            style: .init(
                textColor: .milk,
                backgroundColor: .primaryBlue,
                logoBackgroundColor: .white,
                actionButtonStyle: nil
            )
        )
    }
}
