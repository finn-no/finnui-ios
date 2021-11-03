import UIKit
import FinniversKit

public protocol RealestateAgencyContentViewDelegate: AnyObject {
    func realestateAgencyContentView(
        _ view: RealestateAgencyContentView,
        didSelectActionButtonForArticleAt articleIndex: Int
    )
}

public class RealestateAgencyContentView: UIView {

    // MARK: - Public properties

    public weak var delegate: RealestateAgencyContentViewDelegate?

    // MARK: - Private properties

    private var articleStackView: UIStackView?
    private lazy var logoImageWrapperView = RealestateAgencyLogoWrapperView(withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(logoImageWrapperView)

        NSLayoutConstraint.activate([
            logoImageWrapperView.topAnchor.constraint(equalTo: topAnchor),
            logoImageWrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImageWrapperView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingM),
            logoImageWrapperView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Public methods

    public func configure(
        with viewModel: RealestateAgencyContentViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        articleDirection: NSLayoutConstraint.Axis
    ) {
        // Cleanup potential old views.
        if let articleStackView = articleStackView {
            articleStackView.removeFromSuperview()
            self.articleStackView = nil
        }

        // Setup/configure new views.
        backgroundColor = viewModel.colors.main.background
        logoImageWrapperView.configure(with: viewModel, remoteImageViewDataSource: remoteImageViewDataSource)

        let articleStackView = UIStackView(
            axis: articleDirection,
            spacing: articleDirection.articleSpacing,
            withAutoLayout: true
        )
        articleStackView.distribution = articleDirection.stackViewDistribution

        let articleViews: [UIView]
        if articleDirection == .horizontal, viewModel.articles.count == 1 {
            articleViews = viewModel.articles.map {
                RealestateAgencyHighlightedContentItemView(
                    article: $0,
                    colors: viewModel.colors,
                    remoteImageViewDataSource: remoteImageViewDataSource,
                    delegate: self
                )
            }
        } else {
            articleViews = viewModel.articles.map {
                RealestateAgencyContentItemView(
                    article: $0,
                    colors: viewModel.colors,
                    imageHeight: articleDirection.imageHeight,
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
}

// MARK: - RealestateAgencyContentItemDelegate

extension RealestateAgencyContentView: RealestateAgencyContentItemDelegate {
    func realestateAgencyContentItemDidSelectActionButton(_ view: UIView) {
        guard let viewIndex = articleStackView?.arrangedSubviews.firstIndex(of: view) else {
            return
        }

        delegate?.realestateAgencyContentView(self, didSelectActionButtonForArticleAt: viewIndex)
    }
}

// MARK: - Private extensions

private extension NSLayoutConstraint.Axis {
    var articleSpacing: CGFloat {
        switch self {
        case .horizontal:
            return .spacingL
        case .vertical:
            return .spacingXL
        @unknown default:
            return .spacingXL
        }
    }

    var stackViewDistribution: UIStackView.Distribution {
        switch self {
        case .horizontal:
            return .fillEqually
        case .vertical:
            return .fill
        @unknown default:
            return .fill
        }
    }

    var imageHeight: RealestateAgencyContentItemView.ImageHeight {
        switch self {
        case .horizontal:
            return .constant(200)
        case .vertical:
            return .widthMultiplier()
        @unknown default:
            return .widthMultiplier()
        }
    }
}
