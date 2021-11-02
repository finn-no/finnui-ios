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

    private var imageUrls = [String]()
    private var downloadedImages = [String: UIImage?]()
    private var currentImageUrl: String?

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

    public func configure(with imageUrls: [String]) {
        self.imageUrls = imageUrls
        progressView.configure(withNumberOfProgresses: imageUrls.count)
    }

    public func startStory() {
        showNextImage()
        progressView.startAnimating()
    }

    private func showNextImage() {
        guard !imageUrls.isEmpty else { return }
        let imageUrl = imageUrls.removeFirst()
        self.currentImageUrl = imageUrl

        if !downloadedImages.keys.contains(imageUrl) {
            downloadImage(withUrl: imageUrl)
        } else if let image = downloadedImages[imageUrl] {
            imageView.image = image
        }

        if !imageUrls.isEmpty {
            let nextImageUrl = imageUrls[0]
            downloadImage(withUrl: nextImageUrl)
        }
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
            showNextImage()
        } else {
            // tell delegate to dismiss story
        }
    }
}
