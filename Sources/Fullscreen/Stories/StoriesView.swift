import Foundation
import UIKit

public protocol StoriesViewDataSource: AnyObject {
    func storiesView(_ storiesView: StoriesView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
}

public protocol StoriesViewDelegate: AnyObject {
    
}

public class StoriesView: UIView {
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
        cell.configure(with: story)
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
    func storyCollectionViewCell(_ storyCell: StoryCollectionViewCell, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.storiesView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: completion)
    }

    func storyCollectionViewCell(_ storyCell: StoryCollectionViewCell, slideAtIndexIsFavorite index: Int) -> Bool {
        return false
    }
}

extension StoriesView: StoryCollectionViewCellDelegate {
    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, didSelect action: StoryCollectionViewCell.Action) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }

        switch action {
        case .showNextStory:
            if index + 1 < stories.count {
                scroll(to: index + 1)
            } else {
                // delegate dismiss
            }

        case .showPreviousStory:
            if index - 1 >= 0 {
                scroll(to: index - 1)
            }
        default: break
        }
    }
}
