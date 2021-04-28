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

    // MARK: - Private properties

    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var containerView = SearchDropdownContainerView(contentView: contentStackView, delegate: self, withAutoLayout: true)

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
        backgroundColor = .bgPrimary
        addSubview(containerView)
        containerView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(title: String, buttonTitle: String?) {
        containerView.configure(title: title, buttonTitle: buttonTitle)
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

// MARK: - SearchDropdownContainerViewDelegate

extension SearchDropdownGroupView: SearchDropdownContainerViewDelegate {
    public func searchDropdownContainerViewDidSelectActionButton(_ view: SearchDropdownContainerView) {
        delegate?.searchDropdownGroupViewDidSelectActionButton(self, withIdentifier: identifier)
    }
}
