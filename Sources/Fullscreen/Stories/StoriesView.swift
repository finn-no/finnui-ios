import Foundation
import UIKit
import FinniversKit


public protocol StoriesViewDataSource: AnyObject {
    func storiesView(_ view: StoriesView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
}

public class StoriesView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var progressView: ProgressView = {
        let progressView = ProgressView(withAutoLayout: true)
        progressView.delegate = self
        return progressView
    }()

    private var viewModels = [StoryViewModel]()
    private var images = [UIImage]()

    // MARK: - Public properties

    public weak var dataSource: StoriesViewDataSource?

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(imageView)
        imageView.fillInSuperview()

        addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            progressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            progressView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }

    public func configure(withViewModels viewModels: [StoryViewModel]) {
        self.viewModels = viewModels
    }

    public func configure(with images: [UIImage]) {
        self.images = images
        progressView.configure(withNumberOfProgresses: images.count)
        showNextImage()
        progressView.startAnimating()
    }

    private func showNextImage() {
        guard !images.isEmpty else { return }
        imageView.image = images.removeFirst()
    }
}

extension StoriesView: ProgressViewDelegate {
    func progressViewDidFinishProgress(_ progressView: ProgressView, isLastProgress: Bool) {
        if !isLastProgress {
            showNextImage()
        } else {
            // tell delegate to dismiss story
        }
    }
}
