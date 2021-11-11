import Foundation
import UIKit
import FinniversKit

protocol StoryCollectionViewCellDataSource: AnyObject {
    func storyCollectionViewCell(_ storyCell: StoryCollectionViewCell, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func storyCollectionViewCell(_ storyCell: StoryCollectionViewCell, slideAtIndexIsFavorite index: Int) -> Bool
}

protocol StoryCollectionViewCellDelegate: AnyObject {
    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, didSelect action: StoryCollectionViewCell.Action)
}

class StoryCollectionViewCell: UICollectionViewCell {
    enum Action {
        case showNextStory
        case showPreviousStory
        case goToSearch
        case openAd(slideIndex: Int)
        case toggleFavorite(slideIndex: Int, button: UIButton)
        case share(slideIndex: Int)
    }

    // MARK: - Subviews

    private lazy var searchInfoStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        stackView.alignment = .center
        return stackView
    }()

    private lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = storyIconSize/2
        return imageView
    }()

    private lazy var searchTitleLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.textColor = .milk
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .spacingM
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var priceContainerView: UIVisualEffectView = {
        let view = UIVisualEffectView(withAutoLayout: true)
        view.effect = UIBlurEffect(style: .systemThinMaterialDark)
        view.layer.cornerRadius = priceLabelHeight / 2
        view.clipsToBounds = true
        return view
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.textColor = .textTertiary
        label.backgroundColor = .clear
        return label
    }()

    private lazy var openAdButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleDidSelectAd), for: .touchUpInside)
        return button
    }()

    private lazy var swipeUpIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .arrowUp)
        imageView.tintColor = .milk
        return imageView
    }()

    private lazy var adTitleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textColor = .milk
        label.numberOfLines = 2
        return label
    }()

    private lazy var adDetailLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .milk
        return label
    }()

    private lazy var progressView: ProgressView = {
        let progressView = ProgressView(withAutoLayout: true)
        progressView.delegate = self
        return progressView
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .milk
        button.imageEdgeInsets = UIEdgeInsets(vertical: 3 * .spacingXS, horizontal: 3 * .spacingXS)
        button.addTarget(self, action: #selector(handleFavoriteButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .milk
        button.setImage(UIImage(named: .share).withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(vertical: 3 * .spacingXS, horizontal: 3 * .spacingXS)
        button.addTarget(self, action: #selector(handleShareButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Private properties

    private var currentIndex = 0
    private var didStartAnimating: Bool = false

    private var nextIndex: Int? {
        currentIndex + 1 < slides.count ? currentIndex + 1 : nil
    }

    private var previousIndex: Int? {
        currentIndex - 1 >= 0 ? currentIndex - 1 : nil
    }

    private var slides = [StorySlideViewModel]()
    private var story: Story?
    private var imageUrls = [String]()

    private let storyIconSize: CGFloat = 32
    private let priceLabelHeight: CGFloat = 32

    private var currentImageUrl: String? {
        imageUrls[safe: currentIndex]
    }

    // MARK: - Internal properties

    weak var dataSource: StoryCollectionViewCellDataSource?
    weak var delegate: StoryCollectionViewCellDelegate?
    private(set) var indexPath: IndexPath?

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
        backgroundColor = .storyBackgroundColor

        contentView.addSubview(imageView)
        contentView.addSubview(swipeUpIconImageView)
        contentView.addSubview(openAdButton)
        contentView.addSubview(progressView)
        contentView.addSubview(adTitleLabel)
        contentView.addSubview(adDetailLabel)
        contentView.addSubview(searchInfoStackView)
        contentView.addSubview(priceContainerView)
        contentView.addSubview(shareButton)
        contentView.addSubview(favoriteButton)

        searchInfoStackView.addArrangedSubviews([searchIconImageView, searchTitleLabel])

        priceContainerView.contentView.addSubview(priceLabel)
        priceLabel.fillInSuperview(margin: .spacingS)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: swipeUpIconImageView.topAnchor, constant: -.spacingXS),

            openAdButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            openAdButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            openAdButton.heightAnchor.constraint(equalToConstant: 44),

            swipeUpIconImageView.centerXAnchor.constraint(equalTo: openAdButton.centerXAnchor),
            swipeUpIconImageView.bottomAnchor.constraint(equalTo: openAdButton.topAnchor, constant: -.spacingXS),
            swipeUpIconImageView.heightAnchor.constraint(equalToConstant: 16),
            swipeUpIconImageView.widthAnchor.constraint(equalToConstant: 16),

            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),
            progressView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: .spacingS),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingS),
            progressView.heightAnchor.constraint(equalToConstant: 3),

            searchInfoStackView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            searchInfoStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 3 * .spacingXS),
            searchInfoStackView.trailingAnchor.constraint(lessThanOrEqualTo: progressView.trailingAnchor),

            searchIconImageView.widthAnchor.constraint(equalToConstant: storyIconSize),
            searchIconImageView.heightAnchor.constraint(equalToConstant: storyIconSize),

            adTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            adTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant:  -.spacingM),
            adTitleLabel.bottomAnchor.constraint(equalTo: adDetailLabel.topAnchor, constant: -.spacingXS),

            adDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            adDetailLabel.bottomAnchor.constraint(equalTo: priceContainerView.topAnchor, constant: -.spacingS),
            adDetailLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.spacingS),

            priceContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            priceContainerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -.spacingM),
            priceContainerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            priceContainerView.heightAnchor.constraint(equalToConstant: priceLabelHeight),

            shareButton.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            shareButton.centerYAnchor.constraint(equalTo: priceContainerView.centerYAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 44),
            shareButton.heightAnchor.constraint(equalToConstant: 44),

            favoriteButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        setupGestureRecognizers()
    }

    private func setupGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))

        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleDidSelectAd))
        swipeUpGestureRecognizer.direction = .up
        addGestureRecognizer(swipeUpGestureRecognizer)

        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeftGestureRecognizer.direction = .left
        addGestureRecognizer(swipeLeftGestureRecognizer)

        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGestureRecognizer.direction = .right
        addGestureRecognizer(swipeRightGestureRecognizer)
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.addGradients()
    }

    // MARK: - Public methods

    func configure(with story: Story, indexPath: IndexPath) {
        self.story = story
        self.indexPath = indexPath
        self.slides = story.viewModel.slides
        self.imageUrls = slides.map({ $0.imageUrl })

        showSlide(at: story.slideIndex, downloadImageIsEnabled: false)

        progressView.configure(withNumberOfProgresses: slides.count)
        progressView.setActiveIndex(currentIndex)

        let viewModel = story.viewModel
        searchTitleLabel.text = viewModel.title
        openAdButton.setTitle(viewModel.openAdButtonTitle, for: .normal)

        if let storyIconImageUrl = viewModel.iconImageUrl {
            dataSource?.storyCollectionViewCell(self, loadImageWithPath: storyIconImageUrl, imageWidth: storyIconSize, completion: { [weak self] image in
                self?.searchIconImageView.image = image
            })
        }
    }

    func startStory(durationPerSlideInSeconds: Double = 5) {
        progressView.startAnimating(durationPerSlideInSeconds: durationPerSlideInSeconds)
    }

    func pauseStory() {
        progressView.pauseAnimations()
    }

    func resumeStory() {
        progressView.resumeAnimations()
    }

    func updateFavoriteButtonState() {
        guard let isFavorite = dataSource?.storyCollectionViewCell(self, slideAtIndexIsFavorite: currentIndex) else { return }
        let favoriteImage = isFavorite ? UIImage(named: .favoriteActive) : UIImage(named: .favoriteDefault)
        favoriteButton.setImage(favoriteImage.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    func loadImage() {
        guard let currentImageUrl = currentImageUrl else { return }
        downloadImage(withUrl: currentImageUrl)
        predownloadNextImageIfNeeded()
    }

    // MARK: - Private methods

    private func showNextSlide() {
        guard let nextIndex = nextIndex else {
            delegate?.storyCollectionViewCell(self, didSelect: .showNextStory)
            return
        }
        progressView.setActiveIndex(nextIndex)
        showSlide(at: nextIndex)
    }

    private func showPreviousSlide() {
        guard let previousIndex = previousIndex else {
            delegate?.storyCollectionViewCell(self, didSelect: .showPreviousStory)
            return
        }
        progressView.setActiveIndex(previousIndex)
        showSlide(at: previousIndex)
    }

    private func showSlide(at index: Int, downloadImageIsEnabled: Bool = true) {
        guard let slide = slides[safe: index] else { return }

        currentIndex = index
        story?.slideIndex = currentIndex

        adTitleLabel.text = slide.title
        adDetailLabel.text = slide.detailText

        priceLabel.text = slide.price
        priceLabel.isHidden = slide.price == nil
        updateFavoriteButtonState()

        if let image = story?.images[slide.imageUrl] {
            showImage(image)
        } else if downloadImageIsEnabled {
            imageView.image = nil
            downloadImage(withUrl: slide.imageUrl)
        } else {
            imageView.image = nil
        }

        if downloadImageIsEnabled {
            predownloadNextImageIfNeeded()
        }
    }

    private func predownloadNextImageIfNeeded() {
        guard
            let nextIndex = nextIndex,
            let imageUrl = imageUrls[safe: nextIndex]
        else { return }

        downloadImage(withUrl: imageUrl)
    }

    private func downloadImage(withUrl imageUrl: String) {
        guard
            let story = story,
            !story.images.keys.contains(imageUrl)
        else { return }

        story.images[imageUrl] = nil

        dataSource?.storyCollectionViewCell(self, loadImageWithPath: imageUrl, imageWidth: frame.size.width, completion: { [weak self] image in
            guard let self = self else { return }
            if imageUrl == self.currentImageUrl {
                self.showImage(image)
            }
            if let image = image {
                self.story?.images[imageUrl] = image
            } else {
                // to enable a retry next time the slide is shown
                self.story?.images.removeValue(forKey: imageUrl)
            }
        })
    }

    private func showImage(_ image: UIImage?) {
        guard let image = image else {
            imageView.image = nil
            return
        }
        let contentMode: UIView.ContentMode = image.isLandscapeOrientation ? .scaleAspectFit : .scaleAspectFill
        imageView.contentMode = contentMode
        imageView.image = image
    }

    // MARK: - Actions

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)

        if searchInfoStackView.frame.contains(tapLocation) {
            delegate?.storyCollectionViewCell(self, didSelect: .goToSearch)
        } else if tapLocation.x > frame.size.width / 2 {
            showNextSlide()
        } else {
            showPreviousSlide()
        }
    }

    @objc private func handleDidSelectAd() {
        delegate?.storyCollectionViewCell(self, didSelect: .openAd(slideIndex: currentIndex))
    }

    @objc private func handleSwipeLeft(recognizer: UISwipeGestureRecognizer) {
        // REMOVE?
    }
 
    @objc private func handleSwipeRight(recognizer: UISwipeGestureRecognizer) {
        // REMOVE?
    }

    @objc private func handleFavoriteButtonTap() {
        delegate?.storyCollectionViewCell(self, didSelect: .toggleFavorite(slideIndex: currentIndex, button: favoriteButton))
    }

    @objc private func handleShareButtonTap() {
        delegate?.storyCollectionViewCell(self, didSelect: .share(slideIndex: currentIndex))
    }
}

// MARK: - ProgressViewDelegate

extension StoryCollectionViewCell: ProgressViewDelegate {
    func progressViewDidFinishProgress(_ progressView: ProgressView, isLastProgress: Bool) {
        if !isLastProgress {
            showSlide(at: currentIndex + 1)
        } else {
            delegate?.storyCollectionViewCell(self, didSelect: .showNextStory)
        }
    }
}

extension UIImage {
    var isLandscapeOrientation: Bool {
        return size.width >= size.height
    }
}

extension UIView {
    func addGradients() {
        guard frame.width > 0 else { return }
        if let sublayers = layer.sublayers, !sublayers.isEmpty {
            return
        }
        addGradient(for: .top)
        addGradient(for: .bottom)
    }

    private enum ShadowEdge {
        case top
        case bottom
    }

    private func addGradient(for shadowEdge: ShadowEdge) {
        let gradientLayer = CAGradientLayer()

        switch shadowEdge {
        case .top:
            let radius: CGFloat = 250
            gradientLayer.opacity = 0.5
            gradientLayer.colors = [UIColor.topGradientColor.cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: radius)
        case .bottom:
            let radius: CGFloat = 250
            gradientLayer.opacity = 0.75
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.frame = CGRect(x: 0.0, y: frame.height - radius, width: frame.width, height: radius)
        }

        layer.addSublayer(gradientLayer)
    }
}

private extension UIColor {
    class var topGradientColor: UIColor {
        .dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    class var storyBackgroundColor: UIColor {
        UIColor(hex: "#1B1B24")
    }
}
