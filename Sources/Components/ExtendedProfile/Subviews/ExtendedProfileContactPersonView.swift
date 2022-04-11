import UIKit
import FinniversKit

protocol ExtendedProfileContactPersonViewDelegate: AnyObject {
    func extendedProfileContactPersonView(_ view: ExtendedProfileContactPersonView, didSelectLinkAtIndex linkIndex: Int, contactPersonIndex: Int)
}

class ExtendedProfileContactPersonView: UIView {

    // MARK: - Internal properties

    weak var delegate: ExtendedProfileContactPersonViewDelegate?

    // MARK: - Private properties

    private let contactPersonIndex: Int
    private let contactPerson: CompanyProfile.ContactPerson
    private let style: CompanyProfile.ProfileStyle
    private let portraitImageSize: CGFloat = 72
    private lazy var nameLabel = createLabel(style: .bodyStrong, textColor: style.textColor)
    private lazy var jobTitleLabel = createLabel(style: .detail, textColor: style.textColor)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        stackView.addArrangedSubviews([portraitImageView, nameLabel, jobTitleLabel, linkCollectionView])
        stackView.setCustomSpacing(.spacingXS, after: nameLabel)
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var portraitImageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var linkCollectionView = OverflowCollectionView(
        cellType: ContactPersonLinkCollectionViewCell.self,
        cellSpacing: .init(horizontal: .spacingL, vertical: .spacingXS),
        delegate: self,
        withAutoLayout: true
    )

    // MARK: - Init

    init(
        contactPersonIndex: Int,
        contactPerson: CompanyProfile.ContactPerson,
        style: CompanyProfile.ProfileStyle,
        remoteImageViewDataSource: RemoteImageViewDataSource?,
        delegate: ExtendedProfileContactPersonViewDelegate,
        withAutoLayout: Bool
    ) {
        self.contactPersonIndex = contactPersonIndex
        self.contactPerson = contactPerson
        self.style = style
        self.delegate = delegate

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        portraitImageView.dataSource = remoteImageViewDataSource
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        if let portraitImageUrl = contactPerson.imageUrl {
            portraitImageView.loadImage(for: portraitImageUrl, imageWidth: .zero)
        } else {
            portraitImageView.isHidden = true
        }

        nameLabel.text = contactPerson.name
        jobTitleLabel.text = contactPerson.jobTitle

        addSubview(stackView)
        stackView.fillInSuperview()

        NSLayoutConstraint.activate([
            portraitImageView.widthAnchor.constraint(equalToConstant: portraitImageSize),
            portraitImageView.heightAnchor.constraint(equalToConstant: portraitImageSize),

            linkCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])

        linkCollectionView.configure(with: contactPerson.phoneNumbers)
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()

        if !portraitImageView.isHidden {
            portraitImageView.layer.cornerRadius = portraitImageSize / 2
        }
    }

    // MARK: - Private methods

    private func createLabel(style: Label.Style, textColor: UIColor) -> Label {
        let label = Label(style: style, withAutoLayout: true)
        label.textColor = textColor
        label.numberOfLines = 0
        return label
    }
}

// MARK: - OverflowCollectionViewDelegate

extension ExtendedProfileContactPersonView: OverflowCollectionViewDelegate {
    func overflowCollectionView<Cell>(
        _ view: OverflowCollectionView<Cell>,
        didSelectItemAtIndex index: Int
    ) where Cell: OverflowCollectionViewCell {
        delegate?.extendedProfileContactPersonView(self, didSelectLinkAtIndex: index, contactPersonIndex: contactPersonIndex)
    }

    public func overflowCollectionView<Cell>(
        _ view: OverflowCollectionView<Cell>,
        didConfigureCell cell: Cell,
        atIndex index: Int
    ) where Cell: OverflowCollectionViewCell {
        guard let cell = cell as? ContactPersonLinkCollectionViewCell else { return }
        cell.configure(textColor: style.textColor)
    }
}
