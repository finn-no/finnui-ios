import UIKit
import FinniversKit

final class SearchSuggestionImageResultCollectionViewCell: UICollectionViewCell {

    private let searchListItemView = SearchLandingGroupItemView(frame: CGRect(x: 0, y: 0, width: 100, height: 49))

    static func cellIdentifier() -> String {
        return "SearchSuggestionImageResultCollectionViewCell"
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        searchListItemView.frame = contentView.bounds
        searchListItemView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(searchListItemView)
        searchListItemView.fillInSuperview()
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        //searchListItemView.prepareForReuse()
    }

    // MARK: - Configure

    func configure(with item: SearchLandingGroupItem, remoteImageViewDataSource: RemoteImageViewDataSource) {
        searchListItemView.configure(with: item, remoteImageViewDataSource: remoteImageViewDataSource)
        searchListItemView.backgroundColor = .bgPrimary
    }

}

