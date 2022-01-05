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

    private var agencyContentView: RealestateAgencyContentView?
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
        scrollView.alwaysBounceVertical = true
        addSubview(scrollView)
        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }

    // MARK: - Private methods

    private func configure(numberOfArticles: Int) {
        if let oldView = agencyContentView {
            oldView.removeFromSuperview()
        }

        let view = RealestateAgencyContentView(
            viewModel: .create(numberOfArticles: numberOfArticles),
            delegate: self,
            remoteImageViewDataSource: self,
            withAutoLayout: true
        )

        scrollView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])

        agencyContentView = view
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
            logoUrl: "FINN-LOGO",
            articles: articles,
            styling: RealestateAgencyContentViewModel.Styling(
                textColor: .milk,
                backgroundColor: .primaryBlue,
                logoBackgroundColor: .white,
                actionButton: .init(
                    textColor: .primaryBlue,
                    backgroundColor: .milk,
                    backgroundActiveColor: .milk.withAlphaComponent(0.7),
                    borderColor: .milk
                )
            )
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
