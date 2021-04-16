import UIKit
import FinniversKit

public protocol SearchDropdownGroupViewDelegate: AnyObject {
    func searchDropdownGroupViewDidSelectActionButton(_ view: SearchDropdownGroupView, withIdentifier identifier: String)
    func searchDropdownGroupView(_ view: SearchDropdownGroupView, withIdentifier identifier: String, didSelectItemAtIndex index: Int)
    func searchDropdownGroupView(_ view: SearchDropdownGroupView, withIdentifier identifier: String, didSelectRemoveButtonForItemAtIndex index: Int)
}

public class SearchDropdownGroupView: UIView {

    // MARK: - Public properties

    public let identifier: String
    public weak var delegate: SearchDropdownGroupViewDelegate?

    // MARK: - Private extensions

    private lazy var titleLabel = Label(style: .title3Strong, withAutoLayout: true)
    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    private lazy var actionButton: Button = {
        let button = Button(style: .flat, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView.init(axis: .horizontal, spacing: 0, withAutoLayout: true)
        stackView.alignment = .center
        stackView.addArrangedSubviews([titleLabel, actionButton])
        return stackView
    }()

    // MARK: - Init

    public init(identifier: String, withAutoLayout: Bool = false) {
        self.identifier = identifier
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(headerStackView)
        addSubview(contentStackView)

        let innerLayoutGuide = UILayoutGuide()
        addLayoutGuide(innerLayoutGuide)

        NSLayoutConstraint.activate([
            innerLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            innerLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            innerLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            innerLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),

            headerStackView.topAnchor.constraint(equalTo: innerLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: innerLayoutGuide.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: innerLayoutGuide.trailingAnchor),

            contentStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: .spacingS),
            contentStackView.leadingAnchor.constraint(equalTo: innerLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: innerLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: innerLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(title: String, buttonTitle: String?) {
        titleLabel.text = title

        if let buttonTitle = buttonTitle {
            actionButton.setTitle(buttonTitle, for: .normal)
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }

    public func configure(with items: [SearchDropdownGroupItem], remoteImageViewDataSource: RemoteImageViewDataSource) {
        contentStackView.removeArrangedSubviews()
        let views = items.map {
            SearchDropdownGroupItemView(
                item: $0,
                delegate: self,
                remoteImageViewDataSource: remoteImageViewDataSource,
                withAutoLayout: true
            )
        }
        contentStackView.addArrangedSubviews(views)
    }

    // MARK: - Actions

    @objc private func handleActionButtonTap() {
        delegate?.searchDropdownGroupViewDidSelectActionButton(self, withIdentifier: identifier)
    }
}

// MARK: - SearchDropdownGroupItemViewDelegate

extension SearchDropdownGroupView: SearchDropdownGroupItemViewDelegate {
    func searchDropdownGroupItemViewWasSelected(_ view: SearchDropdownGroupItemView) {
        guard let viewIndex = contentStackView.arrangedSubviews.firstIndex(of: view) else {
            return
        }

        delegate?.searchDropdownGroupView(self, withIdentifier: identifier, didSelectItemAtIndex: viewIndex)
    }

    func searchDropdownGroupItemViewDidSelectRemoveButton(_ view: SearchDropdownGroupItemView) {
        guard let viewIndex = contentStackView.arrangedSubviews.firstIndex(of: view) else {
            return
        }

        delegate?.searchDropdownGroupView(self, withIdentifier: identifier, didSelectRemoveButtonForItemAtIndex: viewIndex)
    }
}
