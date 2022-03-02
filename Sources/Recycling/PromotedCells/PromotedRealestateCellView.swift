import UIKit
import FinniversKit
import MapKit

public protocol PromotedRealestateCellViewDelegate: AnyObject {
    func promotedRealestateCellViewDidToggleFavoriteState(_ view: PromotedRealestateCellView, button: UIButton)
}

public class PromotedRealestateCellView: UIView {

    public enum PromoKind {
        case singleImage // Plus
        case imagesAndMap // Premium
    }

    // MARK: - Public properties

    public weak var delegate: PromotedRealestateCellViewDelegate?

    public var isFavorited: Bool {
        favoriteButton.isToggled
    }

    // MARK: - Private properties

    private let viewModel: PromotedRealestateCellViewModel
    private let promoKind: PromoKind
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    private lazy var viewingInfoView = ViewingInfoView(withAutoLayout: true)
    private lazy var highlightView = UIView(withAutoLayout: true)
    private lazy var titleLabel = createLabel(style: .body, textColor: .textPrimary)
    private lazy var addressLabel = createLabel(style: .caption, textColor: .textSecondary)
    private lazy var primaryAttributesLabel = createLabel(style: .bodyStrong, textColor: .textPrimary)
    private lazy var secondaryAttributesLabel = createLabel(style: .caption, textColor: .textSecondary)
    private lazy var totalPriceLabel = createLabel(style: .caption, textColor: .textSecondary)

    private lazy var imageMapGridView = ImageMapGridView(
        promoKind: promoKind,
        primaryImageUrl: viewModel.primaryImageUrl,
        secondaryImageUrl: viewModel.secondaryImageUrl,
        mapCoordinates: viewModel.mapCoordinates,
        zoomLevel: viewModel.zoomLevel,
        remoteImageViewDataSource: remoteImageViewDataSource
    )

    private lazy var realtorInfoView = RealtorInfoView(
        realtorName: viewModel.realtorName,
        realtorLogoUrl: viewModel.realtorImageUrl,
        remoteImageViewDataSource: remoteImageViewDataSource
    )

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .zero, withAutoLayout: true)
        stackView.addArrangedSubviews([titleLabel, addressLabel, primaryAttributesLabel, totalPriceLabel, secondaryAttributesLabel])
        stackView.setCustomSpacing(.spacingXS, after: titleLabel)
        stackView.setCustomSpacing(.spacingM, after: addressLabel)
        stackView.setCustomSpacing(.spacingS, after: primaryAttributesLabel)
        stackView.setCustomSpacing(.spacingXS, after: totalPriceLabel)
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        stackView.addArrangedSubviews([
            imageMapGridView,
            highlightView,
            realtorInfoView,
            textStackView,
            viewingInfoView
        ])
        stackView.setCustomSpacing(0, after: imageMapGridView)
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var favoriteButton: IconButton = {
        let button = IconButton(style: .favorite)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFavoriteButtonTap), for: .touchUpInside)
        button.imageView?.layer.shadowColor = UIColor.black.cgColor
        button.imageView?.layer.shadowOpacity = 0.7
        button.imageView?.layer.shadowRadius = 2
        button.imageView?.layer.shadowOffset = .zero
        button.tintColor = .white
        return button
    }()

    // MARK: - Init

    public init(
        viewModel: PromotedRealestateCellViewModel,
        promoKind: PromoKind,
        remoteImageViewDataSource: RemoteImageViewDataSource?,
        withAutoLayout: Bool
    ) {
        self.viewModel = viewModel
        self.promoKind = promoKind
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        titleLabel.setTextOrHideIfEmpty(viewModel.title)
        addressLabel.setTextOrHideIfEmpty(viewModel.address)
        primaryAttributesLabel.setTextOrHideIfEmpty(viewModel.primaryAttributes?.joined(separator: " • "))
        secondaryAttributesLabel.setTextOrHideIfEmpty(viewModel.secondaryAttributes?.joined(separator: "・"))
        totalPriceLabel.setTextOrHideIfEmpty(viewModel.totalPriceText)

        highlightView.backgroundColor = viewModel.highlightColor

        addSubview(contentStackView)
        contentStackView.fillInSuperview()
        addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            highlightView.heightAnchor.constraint(equalToConstant: .spacingS),
            highlightView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            imageMapGridView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            realtorInfoView.heightAnchor.constraint(equalToConstant: 28),
            textStackView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])

        if let viewingText = viewModel.viewingText {
            viewingInfoView.configure(with: viewingText, textColor: viewModel.viewingTextColor, backgroundColor: viewModel.viewingBackgroundColor)
        } else {
            viewingInfoView.isHidden = true
        }

        if let ribbonViewModel = viewModel.ribbonViewModel {
            let ribbonView = RibbonView(viewModel: ribbonViewModel)
            ribbonView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(ribbonView)

            NSLayoutConstraint.activate([
                ribbonView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
                ribbonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS)
            ])
        }

        configure(isFavorited: isFavorited)
    }

    // MARK: - Public methods

    public func configure(mapTileOverlay: MKTileOverlay) {
        imageMapGridView.configure(mapTileOverlay: mapTileOverlay)
    }

    public func configure(isFavorited: Bool) {
        favoriteButton.isToggled = isFavorited
    }

    // MARK: - Private methods

    private func createLabel(style: Label.Style, textColor: UIColor) -> Label {
        let label = Label(style: style, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = textColor
        return label
    }

    // MARK: - Actions

    @objc func handleFavoriteButtonTap(_ button: UIButton) {
        delegate?.promotedRealestateCellViewDidToggleFavoriteState(self, button: button)
    }
}

// MARK: - Private extensions

private extension UILabel {
    func setTextOrHideIfEmpty(_ text: String?) {
        if let text = text, !text.isEmpty {
            self.text = text
        } else {
            isHidden = true
        }
    }
}

private extension IconButton.Style {
    static let favorite = IconButton.Style(
        icon: UIImage(named: .notFavorited),
        iconToggled: UIImage(named: .favorited)
    )
}
