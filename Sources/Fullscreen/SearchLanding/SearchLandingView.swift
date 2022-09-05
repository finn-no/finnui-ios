import UIKit
import FinniversKit
import Foundation

public protocol SearchLandingViewDelegate: AnyObject {
    func searchLandingView(didSelectFavoriteButton button: UIButton, forAdWithId adId: String)
}

public final class SearchLandingView: UIView {

    static let headerKind = "headerKind"

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        collectionView.register(SearchSuggestionImageResultCollectionViewCell.self)
        collectionView.register(SearchSuggestionsSectionHeader.self, ofKind: SearchLandingView.headerKind)
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
            heightDimension: .estimated(78)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(.spacingM), trailing: nil, bottom: .fixed(.spacingM))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(49.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: SearchLandingView.headerKind,
                                                                 alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(
            vertical: 0,
            horizontal: Self.horizontalSpacing
        )
        return section
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<SearchLandingSection, SearchLandingGroupItem>
    private var dataSource: DataSource!
    private var sections = [SearchLandingSection]()

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

        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            if let titleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SearchSuggestionsSectionHeader.reuseIdentifier,
                for: indexPath) as? SearchSuggestionsSectionHeader {
                guard let section = self.sections[safe: indexPath.section] else { return nil }
                switch section {
                case .group(let group):
                    titleView.configure(with: group.title)
                default:
                    break
                }
                return titleView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
    }

    

    // MARK: - Snapshot management

    public func configure(with sections: [SearchLandingSection]) {
        self.sections = sections
        print("🕵️‍♀️ configure", sections.description)
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(sections)

        for section in sections {
            switch section {
            case .group(let group):
                print("insertSection group", group.title, group.items)
                snapshot.appendItems(group.items, toSection: section)
            default:
                break
            }
        }
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

