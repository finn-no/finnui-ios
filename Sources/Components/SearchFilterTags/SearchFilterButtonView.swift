import FinniversKit

protocol SearchFilterButtonViewDelegate: AnyObject {
    func searchFilterButtonViewDidSelectFilter(_ searchFilterButtonView: SearchFilterButtonView)
}

final class SearchFilterButtonView: UIView {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = InsetLabel(withAutoLayout: true)
        label.font = SearchFilterTagsView.font
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
        return label
    }()

    private lazy var filterIcon: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    private let title: String

    private static let iconWidth: CGFloat = 15
    fileprivate static let padding: CGFloat = .spacingS

    // MARK: - Internal properties

    static let minWidth: CGFloat = iconWidth + 2 * padding

    var contentWidth: CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: SearchFilterTagsView.height)
        let boundingBox = title.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: SearchFilterTagsView.font],
            context: nil
        )
        return ceil(boundingBox.width) + 2 * SearchFilterButtonView.padding + SearchFilterButtonView.iconWidth + InsetLabel.trailingInset
    }

    weak var delegate: SearchFilterButtonViewDelegate?

    // MARK: - Init

    init(title: String, icon: UIImage) {
        self.title = title
        super.init(frame: .zero)
        titleLabel.text = title
        filterIcon.image = icon.withRenderingMode(.alwaysTemplate)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.borderDefault.cgColor
    }

    // MARK: - Setup

    private func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        addGestureRecognizer(tapGestureRecognizer)

        backgroundColor = .bgPrimary

        layer.cornerRadius = 8
        layer.borderColor = UIColor.borderDefault.cgColor
        layer.borderWidth = 1

        addSubview(filterIcon)
        addSubview(titleLabel)

        let padding = SearchFilterButtonView.padding

        NSLayoutConstraint.activate([
            filterIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            filterIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterIcon.widthAnchor.constraint(equalToConstant: SearchFilterButtonView.iconWidth),
            filterIcon.heightAnchor.constraint(equalTo: filterIcon.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: filterIcon.trailingAnchor, constant: padding),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    // MARK: - Internal methods

    func updateLabel(withAlpha alpha: CGFloat) {
        titleLabel.alpha = alpha
    }

    // MARK: - Actions

    @objc private func filterButtonTapped() {
        delegate?.searchFilterButtonViewDidSelectFilter(self)
    }
}

// MARK: - Private classes

private class InsetLabel: UILabel {
    static let trailingInset: CGFloat = SearchFilterButtonView.padding

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(trailing: InsetLabel.trailingInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + InsetLabel.trailingInset,
            height: size.height
        )
    }
}
