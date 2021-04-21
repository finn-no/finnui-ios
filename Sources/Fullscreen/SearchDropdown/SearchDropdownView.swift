import UIKit
import FinniversKit

public protocol SearchDropdownViewDelegate: AnyObject {
    func searchDropdownView(_ view: SearchDropdownView, didSelectItemAtIndex index: Int, inSection section: SearchDropdownView.Section)
    func searchDropdownView(_ view: SearchDropdownView, didSelectRemoveButtonForItemAtIndex index: Int, inSection section: SearchDropdownView.Section)
    func searchDropdownView(_ view: SearchDropdownView, didSelectActionButtonForSection section: SearchDropdownView.Section)
}

public class SearchDropdownView: UIView {
    public enum Section: String {
        case recentSearches
        case savedSearches
        case popularSearches
    }

    // MARK: - Public properties

    public weak var delegate: SearchDropdownViewDelegate?

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
        stackView.addArrangedSubviews([recentSearchesView, savedSearchesView, popularSearchesView])
        return stackView
    }()

    private lazy var recentSearchesView: SearchDropdownGroupView = {
        let view = SearchDropdownGroupView(identifier: Section.recentSearches.rawValue, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var savedSearchesView: SearchDropdownGroupView = {
        let view = SearchDropdownGroupView(identifier: Section.savedSearches.rawValue, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var popularSearchesView: PopularSearchesView = {
        let view = PopularSearchesView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.arrangedSubviews.forEach { $0.isHidden = true }

        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(title: String, buttonTitle: String? = nil, section: Section) {
        switch section {
        case .recentSearches:
            recentSearchesView.configure(title: title, buttonTitle: buttonTitle)
        case .savedSearches:
            savedSearchesView.configure(title: title, buttonTitle: buttonTitle)
        case .popularSearches:
            popularSearchesView.configure(title: title)
        }
    }

    public func configure(
        recentSearches: [SearchDropdownGroupItem],
        savedSearches: [SearchDropdownGroupItem],
        popularSearches: [String],
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        if !recentSearches.isEmpty {
            recentSearchesView.isHidden = false
            recentSearchesView.configure(with: recentSearches, remoteImageViewDataSource: remoteImageViewDataSource)
        } else {
            recentSearchesView.isHidden = true
        }

        if !savedSearches.isEmpty {
            savedSearchesView.isHidden = false
            savedSearchesView.configure(with: savedSearches, remoteImageViewDataSource: remoteImageViewDataSource)
        } else {
            savedSearchesView.isHidden = true
        }

        if !popularSearches.isEmpty {
            popularSearchesView.isHidden = false
            popularSearchesView.configure(with: popularSearches)
        } else {
            popularSearchesView.isHidden = true
        }
    }
}

// MARK: - SearchDropdownGroupViewDelegate

extension SearchDropdownView: SearchDropdownGroupViewDelegate {
    public func searchDropdownGroupViewDidSelectActionButton(_ view: SearchDropdownGroupView, withIdentifier identifier: String) {
        guard let section = Section(rawValue: identifier) else {
            return
        }
        delegate?.searchDropdownView(self, didSelectActionButtonForSection: section)
    }

    public func searchDropdownGroupView(
        _ view: SearchDropdownGroupView,
        withIdentifier identifier: String,
        didSelectItemAtIndex index: Int
    ) {
        guard let section = Section(rawValue: identifier) else {
            return
        }
        delegate?.searchDropdownView(self, didSelectItemAtIndex: index, inSection: section)
    }

    public func searchDropdownGroupView(
        _ view: SearchDropdownGroupView,
        withIdentifier identifier: String,
        didSelectRemoveButtonForItemAtIndex index: Int
    ) {
        guard let section = Section(rawValue: identifier) else {
            return
        }
        delegate?.searchDropdownView(self, didSelectRemoveButtonForItemAtIndex: index, inSection: section)
    }
}

// MARK: - PopularSearchesViewDelegate

extension SearchDropdownView: PopularSearchesViewDelegate {
    public func popularSearchesView(_ view: PopularSearchesView, didSelectItemAtIndex index: Int) {
        delegate?.searchDropdownView(self, didSelectItemAtIndex: index, inSection: .popularSearches)
    }
}
