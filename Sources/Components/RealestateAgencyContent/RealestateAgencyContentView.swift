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

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
//            logoImageView.trailingAnchor.constraint(lessThanOrEqualTo: centerXAnchor),
            logoImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingS),
            logoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 48)
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
        logoImageView.dataSource = remoteImageViewDataSource
        logoImageView.loadImage(for: viewModel.logoUrl, imageWidth: .zero)

        let articleStackView = UIStackView(
            axis: articleDirection,
            spacing: articleDirection.articleSpacing,
            withAutoLayout: true
        )
        articleStackView.distribution = articleDirection.stackViewDistribution

        let articleViews = viewModel.articles.map { articleItem -> RealestateAgencyContentItemView in
            let view = RealestateAgencyContentItemView(withAutoLayout: true)
            view.delegate = self
            view.configure(with: articleItem, remoteImageViewDataSource: remoteImageViewDataSource)
            return view
        }

        articleStackView.addArrangedSubviews(articleViews)
        addSubview(articleStackView)
        self.articleStackView = articleStackView

        NSLayoutConstraint.activate([
            articleStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: .spacingM),
            articleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            articleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            articleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS)
        ])
    }
}

// MARK: - RealestateAgencyContentItemViewDelegate

extension RealestateAgencyContentView: RealestateAgencyContentItemViewDelegate {
    func realestateAgencyContentItemViewDidSelectActionButton(_ view: RealestateAgencyContentItemView) {
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
            return .spacingS
        case .vertical:
            return .spacingM
        @unknown default:
            return .spacingS
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
}