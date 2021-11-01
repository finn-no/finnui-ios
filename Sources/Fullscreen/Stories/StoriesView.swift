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

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(withAutoLayout: true)
        progressView.progressTintColor = .milk
        progressView.trackTintColor = .sardine.withAlphaComponent(0.5)
        return progressView
    }()

    private var currentIndex: Int? = nil
    private var viewModels = [StoryViewModel]()
    private var images = [UIImage]()
    private var timer: Timer?

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
        ])
    }

    public func configure(withViewModels viewModels: [StoryViewModel]) {
        self.viewModels = viewModels
    }

    public func configure(with images: [UIImage]) {
        currentIndex = nil
        self.images = images
        showNextImage()
    }

    func updateIndex() {
        if currentIndex == nil {
            currentIndex = 0
            return
        }
        if let currentIndex = currentIndex {
            self.currentIndex = currentIndex + 1
        }
    }

    private func showNextImage() {
        updateIndex()

        guard let currentIndex = currentIndex, currentIndex < images.count else {
            // did finish delegate
            return
        }

        imageView.image = images[currentIndex]
        progressView.progress = 0
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }

    @objc func updateProgressView() {
        progressView.progress += 0.001
        progressView.setProgress(progressView.progress, animated: true)
        if progressView.progress == 1 {
            timer?.invalidate()
            showNextImage()
        }
    }
}
