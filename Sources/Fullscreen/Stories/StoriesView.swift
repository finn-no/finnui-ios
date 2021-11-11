import Foundation
import UIKit

public protocol StoriesViewDataSource: AnyObject {
    func storiesView(_ storiesView: StoriesView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func storiesView(_ storiesView: StoriesView, storySlideAtIndexIsFavorite index: StorySlideIndex) -> Bool
}

public protocol StoriesViewDelegate: AnyObject {
    func storiesView(_ storiesView: StoriesView, didSelectAction action: StoriesView.Action)
}

public typealias StorySlideIndex = (storyIndex: Int, slideIndex: Int)

public class StoriesView: UIView {
    public enum Action {
        case goToSearch(storyIndex: Int)
        case openAd(index: StorySlideIndex)
        case toggleFavorite(index: StorySlideIndex, button: UIButton)
        case share(index: StorySlideIndex)
        case dismiss
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CubeCollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(StoryCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private var stories = [Story]()

    public weak var dataSource: StoriesViewDataSource?
    public weak var delegate: StoriesViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    public func configure(with stories: [StoryViewModel]) {
        self.stories = stories.map({ Story(viewModel: $0) })
        collectionView.reloadData()
    }

    public func updateFavoriteStates() {
        for visibleCell in collectionView.visibleCells {
            if let storyViewCell = visibleCell as? StoryCollectionViewCell {
                storyViewCell.updateFavoriteButtonState()
            }
        }
    }

    private func scroll(to index: Int, animated: Bool = true) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
}

extension StoriesView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(StoryCollectionViewCell.self, for: indexPath)
        guard let story = stories[safe: indexPath.item] else { return cell }
        cell.delegate = self
        cell.dataSource = self
        cell.configure(with: story, indexPath: indexPath)
        return cell
    }
}

extension StoriesView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? StoryCollectionViewCell else { return }
        cell.loadImage()
        cell.startStory()
    }
}

extension StoriesView: StoryCollectionViewCellDataSource {
    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.storiesView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: completion)
    }

    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, slideAtIndexIsFavorite index: Int) -> Bool {
        guard
            let storyIndex = cell.indexPath?.item,
            let dataSource = dataSource
        else { return false }

        return dataSource.storiesView(self, storySlideAtIndexIsFavorite: StorySlideIndex(storyIndex: storyIndex, slideIndex: index))
    }
}

extension StoriesView: StoryCollectionViewCellDelegate {
    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, didSelect action: StoryCollectionViewCell.Action) {
        guard let storyIndex = cell.indexPath?.item else { return }

        switch action {
        case .showNextStory:
            if storyIndex + 1 < stories.count {
                scroll(to: storyIndex + 1)
            } else {
                delegate?.storiesView(self, didSelectAction: .dismiss)
            }

        case .showPreviousStory:
            if storyIndex - 1 >= 0 {
                scroll(to: storyIndex - 1)
            }

        case .goToSearch:
            delegate?.storiesView(self, didSelectAction: .goToSearch(storyIndex: storyIndex))

        case .openAd(let slideIndex):
            let index = StorySlideIndex(storyIndex: storyIndex, slideIndex: slideIndex)
            delegate?.storiesView(self, didSelectAction: .openAd(index: index))

        case .share(let slideIndex):
            let index = StorySlideIndex(storyIndex: storyIndex, slideIndex: slideIndex)
            delegate?.storiesView(self, didSelectAction: .share(index: index))

        case .toggleFavorite(let slideIndex, let button):
            let index = StorySlideIndex(storyIndex: storyIndex, slideIndex: slideIndex)
            delegate?.storiesView(self, didSelectAction: .toggleFavorite(index: index, button: button))
        }
    }
}
