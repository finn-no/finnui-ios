import UIKit
import FinniversKit

public protocol SearchSuggestionsViewDelegate: AnyObject {
    func searchSuggestionsView(_ view: SearchSuggestionsView, didSelectResultAt indexPath: IndexPath)
    func searchSuggestionsViewDidSelectViewMoreResults(_ view: SearchSuggestionsView)
}

public class SearchSuggestionsView: UIView {

    // MARK: - Public properties

    public weak var delegate: SearchSuggestionsViewDelegate?

    // MARK: - Private properties

    private var sections = [SearchSuggestionSection]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchSuggestionTableViewCell.self)
        tableView.register(SearchSuggestionMoreResultsTableViewCell.self)
        tableView.register(SearchSuggestionsSectionHeader.self)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        tableView.backgroundColor = .bgPrimary
        return tableView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with sections: [SearchSuggestionSection]) {
        self.sections = sections
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension SearchSuggestionsView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = sections[indexPath.section]

        switch section {
        case .group:
            delegate?.searchSuggestionsView(self, didSelectResultAt: indexPath)
        case .viewMoreResults:
            delegate?.searchSuggestionsViewDidSelectViewMoreResults(self)
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]

        switch section {
        case .group(let group):
            let header = tableView.dequeue(SearchSuggestionsSectionHeader.self)
            header.configure(with: group.title)
            return header
        case .viewMoreResults:
            return UIView(frame: .zero)
        }
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]

        switch section {
        case .group:
            return UITableView.automaticDimension
        case .viewMoreResults:
            return CGFloat.leastNonzeroMagnitude
        }
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]

        switch section {
        case .group:
            return 50
        case .viewMoreResults:
            return CGFloat.leastNonzeroMagnitude
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchSuggestionsView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]

        switch section {
        case .group(let group):
            return group.items.count
        case .viewMoreResults:
            return 1
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section {
        case .group(let group):
            let item = group.items[indexPath.row]
            let cell = tableView.dequeue(SearchSuggestionTableViewCell.self, for: indexPath)
            cell.configure(with: item)
            return cell
        case .viewMoreResults(let title):
            let cell = tableView.dequeue(SearchSuggestionMoreResultsTableViewCell.self, for: indexPath)
            cell.configure(with: title)
            return cell
        }
    }
}
