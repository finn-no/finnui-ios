import Foundation
import UIKit
import FinniversKit


public protocol StoriesViewDataSource: AnyObject {
    func storiesView(_ view: StoriesView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
}

public protocol StoriesViewDelegate: AnyObject {
    func storiesViewDidFinishStory(_ view: StoriesView)
}

public class StoriesView: UIView {

    // MARK: - Subviews

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textColor = .white
        label.dropShadow(color: .licorice, opacity: 1, offset: CGSize(width: 1, height: 2), radius: 2)
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .white
        label.dropShadow(color: .licorice, opacity: 1, offset: CGSize(width: 1, height: 2), radius: 2)
        return label
    }()

    private lazy var progressView: ProgressView = {
        let progressView = ProgressView(withAutoLayout: true)
        progressView.delegate = self
        return progressView
    }()

    // MARK: - Private properties

    private var currentIndex = 0 {
        didSet {
            updateCurrentSlide()
        }
    }

    private var slides = [StorySlideViewModel]()
    private var imageUrls = [String]()
    private var downloadedImages = [String: UIImage?]()
    private let tapGestureRecognizer = UITapGestureRecognizer()

    private var currentImageUrl: String? {
        imageUrls[safe: currentIndex]
    }

    // MARK: - Public properties

    public weak var dataSource: StoriesViewDataSource?
    public weak var delegate: StoriesViewDelegate?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(imageView)
        imageView.fillInSuperview()

        addSubview(progressView)
        addSubview(titleLabel)
        addSubview(detailLabel)

        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(recognizer:)))
        addGestureRecognizer(tapGestureRecognizer)

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            progressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            progressView.heightAnchor.constraint(equalToConstant: 3),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant:  -.spacingM),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.spacingXL),

            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            detailLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -.spacingS),
            detailLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.spacingM),
        ])
    }

    // MARK: - Public methods

    public func configure(with slides: [StorySlideViewModel]) {
        self.slides = slides
        self.imageUrls = slides.map({ $0.imageUrl })

        currentIndex = 0
        progressView.configure(withNumberOfProgresses: slides.count)
    }

    public func startStory(durationPerSlideInSeconds: Double = 5) {
        progressView.startAnimating(durationPerSlideInSeconds: durationPerSlideInSeconds)
    }

    // MARK: - Private methods

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self).x
        if tapLocation > frame.size.width / 2 {
            showNextSlide()
        } else {
            showPreviousSlide()
        }
    }

    private func showNextSlide() {
        guard currentIndex + 1 < slides.count else {
            delegate?.storiesViewDidFinishStory(self)
            return
        }
        currentIndex += 1
    }

    private func showPreviousSlide() {
        currentIndex = max(0, currentIndex - 1)
    }

    private func updateCurrentSlide() {
        guard let slide = slides[safe: currentIndex] else { return }
        progressView.setActiveIndex(currentIndex)

        titleLabel.text = slide.title
        detailLabel.text = slide.detailText

        if let image = downloadedImages[slide.imageUrl] {
            imageView.image = image
        } else {
            imageView.image = nil
            downloadImage(withUrl: slide.imageUrl)
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

// MARK: - ProgressViewDelegate

extension StoriesView: ProgressViewDelegate {
    func progressViewDidFinishProgress(_ progressView: ProgressView, isLastProgress: Bool) {
        if !isLastProgress {
            currentIndex += 1
        } else {
            delegate?.storiesViewDidFinishStory(self)
        }
    }
}
