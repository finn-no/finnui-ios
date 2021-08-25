import UIKit
import FinniversKit

public protocol NumberedAdTipsCollapsibleViewDelegate: AdTipsCollapsibleViewDelegate {
    func numberedAdTipsCollapsibleView(
        _ view: NumberedAdTipsCollapsibleView,
        withIdentifier identifier: String,
        didSelectActionButtonForItem selectedItem: NumberedListItem
    )
}

public class NumberedAdTipsCollapsibleView: AdTipsCollapsibleView {

    // MARK: - Private properties

    private weak var delegate: NumberedAdTipsCollapsibleViewDelegate?
    private lazy var numberedListView = NumberedListView(withAutoLayout: true)
    private var items: [NumberedListItem] = []

    // MARK: - Init

    public init(identifier: String, delegate: NumberedAdTipsCollapsibleViewDelegate, withAutoLayout: Bool = false) {
        self.delegate = delegate
        super.init(
            identifier: identifier,
            imageSize: CGSize(width: 78, height: 78),
            delegate: delegate,
            withAutoLayout: withAutoLayout
        )
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public methods

    public func configure(kind: Kind, title: String, expandCollapseButtonTitles: ButtonTitles, items: [NumberedListItem]) {
        self.items = items
        let numberedListView = NumberedListView(withAutoLayout: true)
        numberedListView.delegate = self
        numberedListView.configure(with: items)
        super.configure(
            with: title,
            expandCollapseButtonTitles: expandCollapseButtonTitles,
            headerImage: kind.image,
            contentView: numberedListView
        )
    }
}

// MARK: - CatDogBuyingTipsView.Kind

extension CatDogBuyingTipsView {
    public enum Kind {
        case cat
        case dog

        fileprivate var image: UIImage {
            switch self {
            case .cat:
                return UIImage(named: .buyingTipsCat)
            case .dog:
                return UIImage(named: .buyingTipsDog)
            }
        }
    }
}

// MARK: - NumberedListViewDelegate

extension NumberedAdTipsCollapsibleView: NumberedListViewDelegate {
    public func numberedListView(_ view: NumberedListView, didSelectActionButtonForItemAt itemIndex: Int) {
        guard items.indices.contains(itemIndex) else { return }
        let item = items[itemIndex]
        delegate?.numberedAdTipsCollapsibleView(self, withIdentifier: identifier, didSelectActionButtonForItem: item)
    }
}
