import UIKit
import FinniversKit

final class SearchSuggestionImageResultCollectionViewCell: UICollectionViewCell {

    private let searchListItemView = SearchDropdownGroupItemView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

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
        backgroundColor = .magenta
        searchListItemView.frame = contentView.bounds
        searchListItemView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(searchListItemView)

        /*
         set default background selected color - make extension for collection view cell like the table view cells have
        contentView.addSubview(searchListItemView)
        searchListItemView?.fillInSuperview()*/
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        //searchListItemView.prepareForReuse()
    }
    /*
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
    }*/

    // MARK: - Configure

    func configure(with item: SearchLandingGroupItem, remoteImageViewDataSource: RemoteImageViewDataSource) {
        searchListItemView.configure(with: item, remoteImageViewDataSource: remoteImageViewDataSource)
    }

}

