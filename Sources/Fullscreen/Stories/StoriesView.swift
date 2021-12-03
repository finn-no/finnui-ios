import Foundation
import UIKit

public protocol StoriesViewDataSource: AnyObject {
    /// If StoriesViewDataSource caches loaded images, StoriesView will prefetch images using loadImageWithPath
    /// before the story is shown. And then call it a second time to retrieve the cached image.
    var cachesLoadedImages: Bool { get }
    func storiesView(_ storiesView: StoriesView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func storiesView(_ storiesView: StoriesView, storySlideAtIndexIsFavorite index: StorySlideIndex) -> Bool
    func storiesView(_ storiesView: StoriesView, slidesForStoryWithIndex index: Int, completion: @escaping (([StorySlideViewModel], Int) -> Void))
}

public protocol StoriesViewDelegate: AnyObject {
    func storiesView(_ storiesView: StoriesView, didSelectAction action: StoriesView.Action)
    func storiesView(_ storiesView: StoriesView, didViewStorySlideWithIndex storySlideIndex: StorySlideIndex)
    func storiesView(_ storiesView: StoriesView, didSelectFeedbackOptionWithIndex index: Int)
    func storiesViewDidDisplayFeedbackModule(_ storiesView: StoriesView)
}

public typealias StorySlideIndex = (storyIndex: Int, slideIndex: Int)

public class StoriesView: UIView {
    public enum Section: Int, CaseIterable {
        case story
        case feedback
    }

    public enum Action {
        case navigateToSearch(storyIndex: Int)
        case navigateToAd(index: StorySlideIndex)
        case toggleFavorite(index: StorySlideIndex, button: UIButton)
        case share(index: StorySlideIndex)
        case dismiss
    }

    // MARK: - Private properties

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CubeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StoryCollectionViewCell.self)
        collectionView.register(FeedbackCollectionViewCell.self)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    private weak var dataSource: StoriesViewDataSource?
    private weak var delegate: StoriesViewDelegate?
    private var currentIndex: Int = 0
    private var stories = [StoryViewModel]()
    private var didSwipeToDismiss: Bool = false
    private var feedbackViewModel: StoryFeedbackViewModel?
    private var startIndex: Int?

    private var isFeedbackEnabled: Bool {
        feedbackViewModel != nil
    }

    private var currentStoryCell: StoryCollectionViewCell? {
        guard stories.indices.contains(currentIndex) else { return nil }
        return collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? StoryCollectionViewCell
    }

    // MARK: - Init

    public init(dataSource: StoriesViewDataSource, delegate: StoriesViewDelegate, withAutoLayout: Bool) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(
        with stories: [StoryViewModel],
        startIndex: Int,
        feedbackViewModel: StoryFeedbackViewModel? = nil
    ) {
        self.stories = stories
        self.startIndex = startIndex
        self.feedbackViewModel = feedbackViewModel
        collectionView.reloadData()
        setNeedsLayout()
    }

    public func resumeStory() {
        if let currentStoryCell = currentStoryCell {
            currentStoryCell.resumeStory()
        }
    }

    public func pauseStory() {
        if let currentStoryCell = currentStoryCell {
            currentStoryCell.pauseStory()
        }
    }

    public func updateFavoriteStates() {
        for visibleCell in collectionView.visibleCells {
            if let storyViewCell = visibleCell as? StoryCollectionViewCell {
                storyViewCell.updateFavoriteButtonState()
            }
        }
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let startIndex = startIndex {
            scrollToStory(at: startIndex, animated: false)
            self.startIndex = nil
        }
    }

    // MARK: - Private methods

    private func scrollToStory(at index: Int, animated: Bool = true) {
        guard stories.indices.contains(index) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        currentIndex = index
    }

    private func scrollToFeedbackCell() {
        guard isFeedbackEnabled else { return }
        let indexPath = IndexPath(item: 0, section: 1)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentIndex = stories.count
    }
}

// MARK: - UICollectionViewDataSource

extension StoriesView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        isFeedbackEnabled ? 2 : 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .story:
            return stories.count
        case .feedback:
            return 1
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }

        if case .feedback = section {
            let cell = collectionView.dequeue(FeedbackCollectionViewCell.self, for: indexPath)
            cell.delegate = self
            if let viewModel = feedbackViewModel {
                cell.configure(with: viewModel)
            }
            return cell
        }

        let cell = collectionView.dequeue(StoryCollectionViewCell.self, for: indexPath)
        guard let story = stories[safe: indexPath.item] else { return cell }

        cell.delegate = self
        cell.dataSource = self
        cell.configure(with: story, indexPath: indexPath)

        dataSource?.storiesView(self, slidesForStoryWithIndex: indexPath.item, completion: { [weak cell] slides, slideStartIndex in
            guard !slides.isEmpty, cell?.indexPath == indexPath else { return }
            cell?.configue(with: slides, startIndex: slideStartIndex)
        })
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StoriesView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? StoryCollectionViewCell {
            cell.prepareForDisplay()
        } else if cell as? FeedbackCollectionViewCell != nil {
            delegate?.storiesViewDidDisplayFeedbackModule(self)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? StoryCollectionViewCell else { return }
        cell.pauseStory()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        currentIndex = Int(scrollView.contentOffset.x / pageWidth)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            collectionView.contentSize.width > 0,
            collectionView.frame.size.width > 0,
            !didSwipeToDismiss
        else { return }

        let swipeDistanceToTriggerDismiss = scrollView.frame.size.width * 0.25

        let swipeToDismissFromFirstCell =
            currentIndex == 0 &&
            scrollView.contentOffset.x < scrollView.frame.minX - swipeDistanceToTriggerDismiss

        let lastCellIndex = isFeedbackEnabled ? stories.count : stories.count - 1
        let swipeToDismissFromLastCell =
            currentIndex == lastCellIndex &&
            scrollView.contentOffset.x > collectionView.contentSize.width - collectionView.frame.size.width + swipeDistanceToTriggerDismiss

        guard swipeToDismissFromFirstCell || swipeToDismissFromLastCell else { return }

        didSwipeToDismiss = true
        delegate?.storiesView(self, didSelectAction: .dismiss)
    }
}

// MARK: - StoryCollectionViewCellDataSource

extension StoriesView: StoryCollectionViewCellDataSource {
    var allowPredownloadOfImages: Bool {
        dataSource?.cachesLoadedImages ?? false
    }

    func storyCollectionViewCell(
        _ cell: StoryCollectionViewCell,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        dataSource?.storiesView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: completion)
    }

    func storyCollectionViewCell(
        _ cell: StoryCollectionViewCell,
        slideAtIndexIsFavorite index: Int
    ) -> Bool {
        guard
            let storyIndex = cell.indexPath?.item,
            let dataSource = dataSource
        else { return false }

        return dataSource.storiesView(self, storySlideAtIndexIsFavorite: StorySlideIndex(storyIndex: storyIndex, slideIndex: index))
    }
}

// MARK: - StoryCollectionViewCellDelegate

extension StoriesView: StoryCollectionViewCellDelegate {
    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, didShowSlideWithIndex index: Int) {
        guard let storyIndex = cell.indexPath?.item else { return }
        delegate?.storiesView(self, didViewStorySlideWithIndex: StorySlideIndex(storyIndex: storyIndex, slideIndex: index))
    }

    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, didSelect action: StoryCollectionViewCell.Action) {
        guard
            let storyIndex = cell.indexPath?.item,
            currentIndex == storyIndex
        else { return }

        switch action {
        case .showNextStory:
            if storyIndex + 1 < stories.count {
                scrollToStory(at: storyIndex + 1)
            } else {
                if isFeedbackEnabled {
                    scrollToFeedbackCell()
                } else {
                    delegate?.storiesView(self, didSelectAction: .dismiss)
                }
            }

        case .showPreviousStory:
            if storyIndex - 1 >= 0 {
                scrollToStory(at: storyIndex - 1)
            }

        case .navigateToSearch:
            delegate?.storiesView(self, didSelectAction: .navigateToSearch(storyIndex: storyIndex))

        case .navigateToAd(let slideIndex):
            let index = StorySlideIndex(storyIndex: storyIndex, slideIndex: slideIndex)
            delegate?.storiesView(self, didSelectAction: .navigateToAd(index: index))

        case .share(let slideIndex):
            let index = StorySlideIndex(storyIndex: storyIndex, slideIndex: slideIndex)
            delegate?.storiesView(self, didSelectAction: .share(index: index))

        case .toggleFavorite(let slideIndex, let button):
            let index = StorySlideIndex(storyIndex: storyIndex, slideIndex: slideIndex)
            delegate?.storiesView(self, didSelectAction: .toggleFavorite(index: index, button: button))

        case .dismiss:
            delegate?.storiesView(self, didSelectAction: .dismiss)
        }
    }
}

// MARK: - FeedbackCollectionViewCellDelegate

extension StoriesView: FeedbackCollectionViewCellDelegate {
    func feedbackCollectionViewCell(_ feedbackCollectionViewCell: FeedbackCollectionViewCell, didSelectOptionWithIndex index: Int) {
        delegate?.storiesView(self, didSelectFeedbackOptionWithIndex: index)
    }

    func feedbackCollectionViewCell(_ feedbackCollectionViewCell: FeedbackCollectionViewCell, didSelectAction action: FeedbackCollectionViewCell.Action) {
        switch action {
        case .next, .dismiss:
            // Next is equal to dismiss, since it's the last cell.
            delegate?.storiesView(self, didSelectAction: .dismiss)
        case .previous:
            if let lastStoryIndex = stories.indices.last {
                scrollToStory(at: lastStoryIndex)
            }
        }
    }
}
