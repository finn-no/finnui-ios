import UIKit
import FinniversKit

class SearchSuggestionImageResultTableViewCell: UITableViewCell {

    // MARK: - Private properties

    private var searchListItemView: SearchListGroupItemView?

    // MARK: - Init

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .magenta

        setDefaultSelectedBackgound()


        /*
        contentView.addSubview(searchListItemView)
        searchListItemView?.fillInSuperview()*/
    }

    // MARK: - Configure

    func configure(with item: SearchSuggestionGroupItem) {
        
    }
}

