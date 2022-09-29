import UIKit
import FinniversKit

final class SearchSuggestionImageResultCollectionViewCell: UICollectionViewCell {

    private let searchListItemView = SearchLandingGroupItemView(frame: .zero)
    private let searchListImageItemView = SearchLandingGroupImageItemView(frame: .zero)

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
        searchListItemView.fillInSuperview(insets: UIEdgeInsets(top: 0, leading: 0, bottom: -.spacingM, trailing: 0))

        searchListImageItemView.frame = contentView.bounds
        searchListImageItemView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(searchListImageItemView)
        searchListImageItemView.fillInSuperview(insets: UIEdgeInsets(top: 0, leading: 0, bottom: -.spacingM, trailing: 0))
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        //searchListItemView.prepareForReuse()
    }

    // MARK: - Configure

    func configure(with item: SearchLandingGroupItem, remoteImageViewDataSource: RemoteImageViewDataSource) {
        if item.imageUrl == nil {
            searchListItemView.configure(with: item)
            searchListImageItemView.isHidden = true
            searchListItemView.isHidden = false
        } else {
            searchListImageItemView.configure(with: item, remoteImageViewDataSource: remoteImageViewDataSource)
            searchListItemView.isHidden = true
            searchListImageItemView.isHidden = false
        }

    }

}

