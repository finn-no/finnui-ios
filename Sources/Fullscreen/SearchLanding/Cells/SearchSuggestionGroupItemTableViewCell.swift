import UIKit
class SearchSuggestionGroupItemTableViewCell: UITableViewCell {
    // MARK: - Private properties

    private lazy var groupItemView = SearchListGroupItemView(item: <#T##SearchListGroupItem#>, delegate: <#T##searchListItemViewDelegate#>, remoteImageViewDataSource: <#T##RemoteImageViewDataSource#>)

    // MARK: - Init

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
}
