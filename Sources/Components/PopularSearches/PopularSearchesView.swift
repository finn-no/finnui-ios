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
    private lazy var collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var containerView = SearchDropdownContainerView(contentView: collectionView, withAutoLayout: true)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PopularSearchCollectionViewCell.self)
        collectionView.backgroundColor = .bgPrimary
        return collectionView
    }()

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
        collectionViewHeightConstraint.isActive = true
    }

    // MARK: - Public methods

    public func configure(title: String) {
        containerView.configure(title: title, buttonTitle: nil)
    }

    public func configure(with items: [String]) {
        popularItems = items
        collectionView.reloadData()

        layoutIfNeeded()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint.constant = contentHeight
    }
}

// MARK: - Private class

extension PopularSearchesView {
    private class CollectionViewLayout: UICollectionViewFlowLayout {
        private let spacing = CGFloat.spacingS

        override init() {
            super.init()
            scrollDirection = .vertical
            minimumInteritemSpacing = spacing
            minimumLineSpacing = spacing
        }

        required init?(coder: NSCoder) { fatalError() }

        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let attributes = super.layoutAttributesForElements(in: rect) else {
                return nil
            }

            attributes.enumerated().forEach { index, attribute in
                // Skip the first attribute, that one's already correctly placed.
                guard index > 0 else { return }

                let origin = attributes[index - 1].frame.maxX

                // Make sure the new cell is not exceeding the width of the collectionView.
                if origin + spacing + attribute.frame.size.width < collectionViewContentSize.width {
                    var newFrame = attribute.frame
                    newFrame.origin.x = origin + spacing
                    attribute.frame = newFrame
                }
            }

            return attributes
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PopularSearchesView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.popularSearchesView(self, didSelectItemAtIndex: indexPath.item)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let title = popularItems[indexPath.item]
        let font = PopularSearchCollectionViewCell.titleLabelStyle.font
        let padding = PopularSearchCollectionViewCell.padding

        let width = title.width(withConstrainedHeight: .infinity, font: font) + (padding.leading + padding.trailing)
        let height = title.height(withConstrainedWidth: .infinity, font: font) + (padding.top + padding.bottom)

        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDataSource

extension PopularSearchesView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        popularItems.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PopularSearchCollectionViewCell.self, for: indexPath)
        cell.configure(with: popularItems[indexPath.item])
        return cell
    }
}

// MARK: - SearchDropdownContainerViewDelegate

extension PopularSearchesView: SearchDropdownContainerViewDelegate {
    public func searchDropdownContainerViewDidSelectActionButton(_ view: SearchDropdownContainerView) {}
}
