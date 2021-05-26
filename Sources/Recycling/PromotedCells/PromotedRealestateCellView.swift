import UIKit
import FinniversKit
import MapKit

public class PromotedRealestateCellView: UIView {

    public enum PromoKind {
        case singleImage
        case imagesAndMap
    }

    // MARK: - Private properties

    private let viewModel: PromotedRealestateCellViewModel
    private let promoKind: PromoKind
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    private lazy var imageMapGridView = ImageMapGridView(
        promoKind: promoKind,
        primaryImageUrl: viewModel.primaryImageUrl,
        secondaryImageUrl: viewModel.secondaryImageUrl,
        mapCoordinates: viewModel.mapCoordinates,
        remoteImageViewDataSource: remoteImageViewDataSource
    )

    private lazy var realtorInfoView = RealtorInfoView(
        realtorName: viewModel.realtorName,
        realtorLogoUrl: viewModel.realtorImageUrl,
        remoteImageViewDataSource: remoteImageViewDataSource
    )

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var addressLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = .textSecondary
        return label
    }()

    private lazy var primaryAttributesLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var secondaryAttributesLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = .textSecondary
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        stackView.addArrangedSubviews([titleLabel, addressLabel, primaryAttributesLabel, secondaryAttributesLabel])
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .zero, withAutoLayout: true)
        return stackView
    }()

    private lazy var highlightView = UIView(withAutoLayout: true)

    // MARK: - Init

    public init(
        viewModel: PromotedRealestateCellViewModel,
        promoKind: PromoKind,
        remoteImageViewDataSource: RemoteImageViewDataSource,
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
        titleLabel.text = viewModel.title
        addressLabel.text = viewModel.address
        primaryAttributesLabel.text = viewModel.primaryAttributes.joined(separator: " • ")
        secondaryAttributesLabel.text = viewModel.secondaryAttributes.joined(separator: "・")
        highlightView.backgroundColor = viewModel.highlightColor

        addSubview(imageMapGridView)
        addSubview(highlightView)
        addSubview(realtorInfoView)
        addSubview(textStackView)

        NSLayoutConstraint.activate([
            imageMapGridView.topAnchor.constraint(equalTo: topAnchor),
            imageMapGridView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageMapGridView.trailingAnchor.constraint(equalTo: trailingAnchor),

            highlightView.topAnchor.constraint(equalTo: imageMapGridView.bottomAnchor),
            highlightView.leadingAnchor.constraint(equalTo: leadingAnchor),
            highlightView.trailingAnchor.constraint(equalTo: trailingAnchor),
            highlightView.heightAnchor.constraint(equalToConstant: .spacingS),

            realtorInfoView.topAnchor.constraint(equalTo: highlightView.bottomAnchor, constant: .spacingS),
            realtorInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            realtorInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textStackView.topAnchor.constraint(equalTo: realtorInfoView.bottomAnchor, constant: .spacingS),
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(mapTileOverlay: MKTileOverlay) {
        imageMapGridView.configure(mapTileOverlay: mapTileOverlay)
    }
}
