import UIKit
import FinniversKit
import FinnUI

class RealestateAgencyContentDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "3 articles", action: { [weak self] in
            self?.configure(numberOfArticles: 3)
        }),
        TweakingOption(title: "2 articles", action: { [weak self] in
            self?.configure(numberOfArticles: 2)
        }),
        TweakingOption(title: "1 article", action: { [weak self] in
            self?.configure(numberOfArticles: 1)
        }),
        TweakingOption(title: "0 articles", action: { [weak self] in
            self?.configure(numberOfArticles: 0)
        })
    ]

    // MARK: - Private properties

    private lazy var agencyContentView = RealestateAgencyContentView(withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        agencyContentView.delegate = self

        scrollView.alwaysBounceVertical = true
        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(agencyContentView)

        agencyContentView.fillInSuperview(margin: .spacingM)
        agencyContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL).isActive = true
    }

    // MARK: - Private methods

    private func configure(numberOfArticles: Int) {
        let viewModel = RealestateAgencyContentViewModel.create(numberOfArticles: numberOfArticles)
        agencyContentView.configure(
            with: viewModel,
            remoteImageViewDataSource: self,
            articleDirection: UITraitCollection.current.horizontalSizeClass == .compact ? .vertical : .horizontal
        )
    }
}

// MARK: - Private extensions

private extension RealestateAgencyContentViewModel {
    static func create(numberOfArticles: Int) -> RealestateAgencyContentViewModel {
        let articles = (0..<numberOfArticles).map { index -> ArticleItem in
            let title = (0...index).map { _ in "Vi hjelper deg med boligsalget." }.joined(separator: " ")
            return ArticleItem(
                title: title,
                body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nullam eget felis eget nunc lobortis. Faucibus ornare suspendisse sed nisi. Pretium lectus quam id leo in vitae turpis massa sed. ",
                imageUrl: "https://stockphoto.com/samples/OTQ5NTM5MTEwMDAxMWY1YmNmYjBlZA==/MjIxMWY1YmNmYjBlZA==/elephant-on-rope.jpg&size=512",
                buttonTitle: "Bli kjent med salgsprosessen",
                buttonKind: index == 0 ? .highlighted : .normal
            )
        }

        return RealestateAgencyContentViewModel(
            logoUrl: "https://kommunikasjon.ntb.no/data/images/00171/daaffdf6-fb0e-4e74-9b6b-7f973dbfa6a3.png",
            articles: articles
        )
    }
}

// MARK: - RealestateAgencyContentItemViewDelegate

extension RealestateAgencyContentDemoView: RealestateAgencyContentViewDelegate {
    func realestateAgencyContentView(
        _ view: RealestateAgencyContentView,
        didSelectActionButtonForArticleAt articleIndex: Int
    ) {
        print("✅ Did select actionButton for article at \(articleIndex)")
    }
}

// MARK: - RemoteImageViewDataSource

extension RealestateAgencyContentDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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
