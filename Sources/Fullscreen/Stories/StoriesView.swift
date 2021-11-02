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

    private var currentIndex = 0
    private var imageUrls = [String]()
    private var downloadedImages = [String: UIImage?]()
    private let tapGestureRecognizer = UITapGestureRecognizer()

    private var currentImageUrl: String? {
        imageUrls[safe: currentIndex]
    }

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

        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(recognizer:)))
        addGestureRecognizer(tapGestureRecognizer)

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            progressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            progressView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }

    public func configure(with imageUrls: [String]) {
        self.imageUrls = imageUrls
        progressView.configure(withNumberOfProgresses: imageUrls.count)
    }

    public func startStory() {
        currentIndex = 0
        showImage(forIndex: currentIndex)
        progressView.startAnimating()
    }

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self).x
        if tapLocation > frame.size.width / 2 {
            showNextSlide()
        } else {
            showPreviousSlide()
        }
    }

    private func showNextSlide() {
        guard currentIndex + 1 < imageUrls.count else {
            // Tell delegate to finish
            return
        }
        currentIndex += 1
        progressView.setActiveIndex(currentIndex)
        showImage(forIndex: currentIndex)
    }

    private func showPreviousSlide() {
        currentIndex = max(0, currentIndex - 1)
        progressView.setActiveIndex(currentIndex)
        showImage(forIndex: currentIndex)
    }

    private func showImage(forIndex index: Int) {
        guard let imageUrl = imageUrls[safe: index] else { return }

        if let image = downloadedImages[imageUrl] {
            imageView.image = image
        } else {
            downloadImage(withUrl: imageUrl)
        }

        predownloadNextImageIfNeeded()
    }

    private func predownloadNextImageIfNeeded() {
        guard let imageUrl = imageUrls[safe: currentIndex + 1] else { return }
        downloadImage(withUrl: imageUrl)
    }

    private func downloadImage(withUrl imageUrl: String) {
        guard !downloadedImages.keys.contains(imageUrl) else { return }
        downloadedImages[imageUrl] = nil

        dataSource?.storiesView(self, loadImageWithPath: imageUrl, imageWidth: frame.size.width, completion: { [weak self] image in
            guard let self = self else { return }
            if imageUrl == self.currentImageUrl {
                self.imageView.image = image
            } else {
                self.downloadedImages[imageUrl] = image
            }
        })
    }
}

extension StoriesView: ProgressViewDelegate {
    func progressViewDidFinishProgress(_ progressView: ProgressView, isLastProgress: Bool) {
        if !isLastProgress {
            currentIndex += 1
            showImage(forIndex: currentIndex)
        } else {
            // tell delegate to dismiss story
        }
    }
}
