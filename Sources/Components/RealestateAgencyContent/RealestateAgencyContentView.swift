import UIKit
import FinniversKit

public protocol RealestateAgencyContentViewDelegate: AnyObject {
    func realestateAgencyContentView(
        _ view: RealestateAgencyContentView,
        didSelectActionButtonForArticle article: RealestateAgencyContentViewModel.ArticleItem
    )
}

public class RealestateAgencyContentView: UIView {

    // MARK: - Private properties

    private let viewModel: RealestateAgencyContentViewModel
    private var articleStackView: UIStackView?
    private weak var delegate: RealestateAgencyContentViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private lazy var logoImageWrapperView = RealestateAgencyLogoWrapperView(withAutoLayout: true)

    // MARK: - Init

    public init(
        viewModel: RealestateAgencyContentViewModel,
        delegate: RealestateAgencyContentViewDelegate,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
        presentArticles()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = 8
<<<<<<< HEAD
        backgroundColor = viewModel.styling.backgroundColor
        logoImageWrapperView.configure(imageUrl: viewModel.logoUrl, backgroundColor: viewModel.styling.logoBackgroundColor, remoteImageViewDataSource: remoteImageViewDataSource)
=======
        backgroundColor = viewModel.style.backgroundColor
        logoImageWrapperView.configure(imageUrl: viewModel.logoUrl, backgroundColor: viewModel.style.logoBackgroundColor, remoteImageViewDataSource: remoteImageViewDataSource)
>>>>>>> master

        addSubview(logoImageWrapperView)

        NSLayoutConstraint.activate([
            logoImageWrapperView.topAnchor.constraint(equalTo: topAnchor),
            logoImageWrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImageWrapperView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingM),
            logoImageWrapperView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Private methods

    private func presentArticles() {
        guard let remoteImageViewDataSource = remoteImageViewDataSource else { return }

        // Cleanup potential old views.
        if let articleStackView = articleStackView {
            articleStackView.removeFromSuperview()
            self.articleStackView = nil
        }

        let horizontalSizeClass = traitCollection.horizontalSizeClass

        let articleStackView = UIStackView(
            axis: horizontalSizeClass.articleDirection,
            spacing: horizontalSizeClass.articleSpacing,
            withAutoLayout: true
        )
        articleStackView.distribution = horizontalSizeClass.stackViewDistribution

        let articleViews: [UIView]
        if horizontalSizeClass == .regular, viewModel.articles.count == 1 {
            articleViews = viewModel.articles.map {
                RealestateAgencyHighlightedContentItemView(
                    article: $0,
<<<<<<< HEAD
                    styling: viewModel.styling,
=======
                    style: viewModel.style,
>>>>>>> master
                    remoteImageViewDataSource: remoteImageViewDataSource,
                    delegate: self
                )
            }
        } else {
            articleViews = viewModel.articles.map {
                RealestateAgencyContentItemView(
                    article: $0,
<<<<<<< HEAD
                    styling: viewModel.styling,
=======
                    style: viewModel.style,
>>>>>>> master
                    imageHeight: horizontalSizeClass.imageHeight,
                    remoteImageViewDataSource: remoteImageViewDataSource,
                    delegate: self
                )
            }
        }

        articleStackView.addArrangedSubviews(articleViews)
        addSubview(articleStackView)
        self.articleStackView = articleStackView

        NSLayoutConstraint.activate([
            articleStackView.topAnchor.constraint(equalTo: logoImageWrapperView.bottomAnchor, constant: .spacingM),
            articleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            articleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            articleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingL)
        ])
    }

    // MARK: - Overrides

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            presentArticles()
        }
    }
}

// MARK: - RealestateAgencyContentItemDelegate

extension RealestateAgencyContentView: RealestateAgencyContentItemDelegate {
    func realestateAgencyContentItemDidSelectActionButton(_ view: UIView) {
        guard let viewIndex = articleStackView?.arrangedSubviews.firstIndex(of: view) else {
            return
        }

        let article = viewModel.articles[viewIndex]
        delegate?.realestateAgencyContentView(self, didSelectActionButtonForArticle: article)
    }
}

// MARK: - Private extensions

private extension UIUserInterfaceSizeClass {
    var articleDirection: NSLayoutConstraint.Axis {
        switch self {
        case .regular:
            return .horizontal
        default:
            return .vertical
        }
    }

    var articleSpacing: CGFloat {
        switch self {
        case .regular:
            return .spacingL
        default:
            return .spacingXL
        }
    }

    var stackViewDistribution: UIStackView.Distribution {
        switch self {
        case .regular:
            return .fillEqually
        default:
            return .fill
        }
    }

    var imageHeight: RealestateAgencyContentItemView.ImageHeight {
        switch self {
        case .regular:
            return .constant(200)
        default:
            return .widthMultiplier()
        }
    }
}
