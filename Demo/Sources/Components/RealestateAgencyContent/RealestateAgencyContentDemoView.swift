import UIKit
import FinniversKit
import FinnUI
import DemoKit

class RealestateAgencyContentDemoView: UIView {

    // MARK: - Private properties

    private var agencyContentView: RealestateAgencyContentView?
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
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
            view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: .spacingM),
            view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: .spacingM),
            view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -.spacingM),
            view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -.spacingM)
        ])

        agencyContentView = view
    }
}

// MARK: - TweakableDemo

extension RealestateAgencyContentDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case threeArticles
        case twoArticles
        case oneArticle
        case zeroArticles
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .threeArticles:
            configure(numberOfArticles: 3)
        case .twoArticles:
            configure(numberOfArticles: 2)
        case .oneArticle:
            configure(numberOfArticles: 1)
        case .zeroArticles:
            configure(numberOfArticles: 0)
        }
    }
}

// MARK: - Private extensions

private extension RealestateAgencyContentViewModel {
    static func create(numberOfArticles: Int) -> RealestateAgencyContentViewModel {
        let articles = (0..<numberOfArticles).map { index -> ArticleItem in
            let title = (0...index).map { _ in "Vi hjelper deg med boligsalget." }.joined(separator: " ")
            let buttonTitle = index == 2 ? "Veldig veldig veldig lang knappetekst over 2 linjer" : "Bli kjent med salgsprosessen"

            return ArticleItem(
                title: title,
                body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nullam eget felis eget nunc lobortis. Faucibus ornare suspendisse sed nisi. Pretium lectus quam id leo in vitae turpis massa sed. ",
                imageUrl: "https://stockphoto.com/samples/OTQ5NTM5MTEwMDAxMWY1YmNmYjBlZA==/MjIxMWY1YmNmYjBlZA==/elephant-on-rope.jpg&size=512",
                buttonTitle: buttonTitle,
                buttonKind: index == 0 ? .highlighted : .normal,
                articleUrl: "https://finn.no"
            )
        }

        return RealestateAgencyContentViewModel(
            logoUrl: "FINN-LOGO",
            articles: articles,
            style: .init(
                textColor: .milk,
                backgroundColor: .primaryBlue,
                logoBackgroundColor: .white,
                actionButtonStyle: .init(
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
        didSelectActionButtonForArticle article: RealestateAgencyContentViewModel.ArticleItem
    ) {
        print("✅ Did select actionButton for article with title \(article.title)")
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
