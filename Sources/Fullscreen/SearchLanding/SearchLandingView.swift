import UIKit
import FinniversKit
import Foundation

public protocol SearchLandingViewDelegate: AnyObject {
    func searchLandingView(didSelectFavoriteButton button: UIButton, forAdWithId adId: String)
}

public final class SearchLandingView: UIView {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .magenta
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        collectionView.register(SearchSuggestionImageResultCollectionViewCell.self)

        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            return Self.createFullWidthSection()
        }
        return layout
    }()

    private static func createFullWidthSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(106)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(.spacingM), trailing: nil, bottom: .fixed(.spacingM))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            vertical: 0,
            horizontal: Self.horizontalSpacing
        )
        return section
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<SearchLandingSection, SearchLandingGroupItem>
    private var dataSource: DataSource!

    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchLandingSection, SearchLandingGroupItem>

    private weak var delegate: SearchLandingViewDelegate?

    private var remoteImageViewDataSource: RemoteImageViewDataSource

    // MARK: - Internal properties

    static let horizontalSpacing: CGFloat = .spacingS

    // MARK: - Init

    public init(
        withAutoLayout: Bool,
        delegate: SearchLandingViewDelegate?,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        print("🕵️‍♀️ init")
        self.delegate = delegate
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        configureDataSource()
        addSubview(collectionView)
        collectionView.fillInSuperview()
        print("🕵️‍♀️ CV", collectionView.numberOfSections)
    }

    private func configureDataSource() {
        print("🕵️‍♀️ \(#function)")
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                print("🕵️‍♀️ item", item)
                let cell = collectionView.dequeue(SearchSuggestionImageResultCollectionViewCell.self, for: indexPath)
                cell.configure(with: item, remoteImageViewDataSource: self.remoteImageViewDataSource)
                return cell
            }
        )
        print("🕵️‍♀️ \(#function)")
    }

    // MARK: - Snapshot management

    public func configure(with section: [SearchLandingSection]) {
        print("🕵️‍♀️ configure", section.description)
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.viewMoreResults(title: "Test")])
        snapshot.insertSections(section)
        applySnapshot(snapshot)
    }


    private func applySnapshot(_ snapshot: Snapshot, animatingDifferences: Bool = true) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }

    }

}



// MARK: - UICollectionViewDelegate

extension SearchLandingView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

// MARK: - Private extensions

private extension NSDiffableDataSourceSnapshot where SectionIdentifierType == SearchLandingSection, ItemIdentifierType == SearchLandingGroupItem {
    mutating func insertSections(_ sections: [SearchLandingSection]) {
        insertSections(sections, beforeSection: .viewMoreResults(title: "Test"))
        for section in sections {
            switch section {
            case .group(let group):
                appendItems(group.items)
            default:
                break
            }
        }
    }
}
