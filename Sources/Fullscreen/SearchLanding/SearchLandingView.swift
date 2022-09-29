import UIKit
import FinniversKit
import Foundation

public protocol SearchLandingViewDelegate: AnyObject {
    func searchLandingView(didSelectFavoriteButton button: UIButton, forAdWithId adId: String)
    func searchLandingView(_ view: SearchLandingView, didSelectResultAt indexPath: IndexPath, uuid: UUID)
    func searchLandingView(didTapEnableLocationButton button: UIButton)
}

public final class SearchLandingView: UIView {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = .bgPrimary

        collectionView.register(SearchSuggestionImageResultCollectionViewCell.self)
        collectionView.register(SearchSuggestionLocationPermissionCell.self)
        collectionView.register(SearchSuggestionMoreResultsCollectionViewCell.self)
        collectionView.register(SearchSuggestionsSectionHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(SearchSuggestionsSectionFooter.self, ofKind: UICollectionView.elementKindSectionFooter)
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
        //item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(.spacingM), trailing: nil, bottom: .fixed(.spacingM))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])


        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(48.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(7.0))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer]
        section.contentInsets = NSDirectionalEdgeInsets(
            vertical: 0,
            horizontal: Self.horizontalSpacing
        )
        return section
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<SearchLandingSection, SearchLandingGroupItem>
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item.type {
                case .searchResult:
                    let cell = collectionView.dequeue(SearchSuggestionImageResultCollectionViewCell.self, for: indexPath)
                    cell.configure(with: item, remoteImageViewDataSource: self.remoteImageViewDataSource)
                    return cell
                case .locationPermission:
                    let cell = collectionView.dequeue(SearchSuggestionLocationPermissionCell.self, for: indexPath)
                    cell.configure(with: item.title)
                    cell.delegate = self.delegate
                    return cell
                case .showMoreResults:
                    let cell = collectionView.dequeue(SearchSuggestionMoreResultsCollectionViewCell.self, for: indexPath)
                    cell.configure(with: item.title)
                    return cell
                }
            }
        )

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            if kind == "UICollectionElementKindSectionHeader" {
                guard let section = self?.sections[safe: indexPath.section] else { return SearchSuggestionsSectionHeader() }
                let view = collectionView.dequeue(
                    SearchSuggestionsSectionHeader.self,
                    for: indexPath,
                    ofKind: UICollectionView.elementKindSectionHeader
                )
                switch section {
                case .group(let group):
                    guard group.items.count > 0 else { return SearchSuggestionsSectionHeader() }
                    view.configure(with: group.title)
                case .viewMoreResults(title: let title):
                    view.configure(with: "")
                case .locationPermission(title: let title):
                    view.configure(with: "")
                }
                return view
            } else if kind == "UICollectionElementKindSectionFooter" {
                guard let section = self?.sections[safe: indexPath.section] else { return SearchSuggestionsSectionFooter() }
                let view = collectionView.dequeue(
                    SearchSuggestionsSectionFooter.self,
                    for: indexPath,
                    ofKind: UICollectionView.elementKindSectionFooter
                )
                switch section {
                case .group(let group):
                    guard group.items.count > 0 else { return SearchSuggestionsSectionFooter() }
                    return view
                default:
                    return view
                }
            }
            return UICollectionReusableView()
        }
        return dataSource
    }()

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
        backgroundColor = .bgTertiary
        addSubview(collectionView)
        collectionView.fillInSuperview(insets: UIEdgeInsets(top: .spacingM, leading: 0, bottom: -.spacingM, trailing: 0))
    }

    // MARK: - Snapshot management

    public func configure(with sections: [SearchLandingSection], delegate: SearchLandingViewDelegate?) {
        self.delegate = delegate
        self.sections = sections
        var snapshot = Snapshot()
        snapshot.appendSections(sections)

        for section in sections {
            switch section {
            case .group(let group):
                snapshot.appendItems(group.items, toSection: section)
            case .locationPermission(let item):
                snapshot.appendItems([item], toSection: section)
            case .viewMoreResults(let item):
                snapshot.appendItems([item], toSection: section)
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
        print(#function, indexPath)
        if let result = dataSource.itemIdentifier(for: indexPath) {
            print("Selected result \(result.title)")
            delegate?.searchLandingView(self, didSelectResultAt: indexPath, uuid: result.uuid)
        }
    }
}

