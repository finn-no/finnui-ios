import UIKit
import FinniversKit

public protocol PopularSearchesViewDelegate: AnyObject {
    func popularSearchesView(_ view: PopularSearchesView, didSelectItemAtIndex index: Int)
}

public class PopularSearchesView: UIView {

    // MARK: - Public properties

    public weak var delegate: PopularSearchesViewDelegate?

    // MARK: - Private properties

    private var popularItems = [String]()
    private lazy var containerView = SearchDropdownContainerView(contentView: overflowCollectionView, withAutoLayout: true)

    private lazy var overflowCollectionView = OverflowCollectionView(
        cellType: PopularSearchCollectionViewCell.self,
        cellSpacing: .init(horizontal: .spacingS, vertical: .spacingS),
        delegate: self,
        withAutoLayout: true
    )

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(containerView)
        containerView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(title: String) {
        containerView.configure(title: title, buttonTitle: nil)
    }

    public func configure(with items: [String]) {
        overflowCollectionView.configure(with: items)
    }
}

// MARK: - OverflowCollectionViewDelegate

extension PopularSearchesView: OverflowCollectionViewDelegate {
    public func overflowCollectionView<Cell>(
        _ view: OverflowCollectionView<Cell>,
        didSelectItemAtIndex index: Int
    ) where Cell: OverflowCollectionViewCell {
        delegate?.popularSearchesView(self, didSelectItemAtIndex: index)
    }
}

// MARK: - SearchDropdownContainerViewDelegate

extension PopularSearchesView: SearchDropdownContainerViewDelegate {
    public func searchDropdownContainerViewDidSelectActionButton(_ view: SearchDropdownContainerView) {}
}
