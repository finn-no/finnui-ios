import Foundation
import UIKit
import FinniversKit

public protocol StoryViewDataSource: AnyObject {
    func storyView(_ view: StoryView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func storyView(_ view: StoryView, slideAtIndexIsFavorite index: Int) -> Bool
}

public protocol StoryViewDelegate: AnyObject {
    func storyViewDidFinishStory(_ view: StoryView)
    func storyViewDidSelectAd(_ view: StoryView)
    func storyViewDidSelectNextStory(_ view: StoryView)
    func storyViewDidSelectPreviousStory(_ view: StoryView)
    func storyViewDidSelectSearch(_ view: StoryView)
    func storyView(_ view: StoryView, didTapFavoriteButton button: UIButton, forIndex index: Int)
    func storyViewDidSelectShare(_ view: StoryView, forIndex index: Int)
}

public class StoryView: UIView {

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
        view.alpha = 1.0
        view.layer.cornerRadius = priceLabelHeight / 2
        view.clipsToBounds = true
        return view
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .captionStrong)
        label.textColor = .textTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var openAdButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleDidSelectAd), for: .touchUpInside)
        return button
    }()

    private lazy var adTitleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textColor = .milk
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

    private var currentIndex = 0 {
        didSet {
            updateCurrentSlide()
        }
    }

    private var slides = [StorySlideViewModel]()
    private var imageUrls = [String]()
    private var downloadedImages = [String: UIImage?]()

    private let storyIconSize: CGFloat = 32
    private let priceLabelHeight: CGFloat = 32

    private var currentImageUrl: String? {
        imageUrls[safe: currentIndex]
    }

    // MARK: - Public properties

    public weak var dataSource: StoryViewDataSource?
    public weak var delegate: StoryViewDelegate?

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

        addSubview(imageView)
        addSubview(openAdButton)
        addSubview(progressView)
        addSubview(adTitleLabel)
        addSubview(adDetailLabel)
        addSubview(searchInfoStackView)
        addSubview(priceContainerView)
        addSubview(shareButton)
        addSubview(favoriteButton)

        searchInfoStackView.addArrangedSubviews([searchIconImageView, searchTitleLabel])

        priceContainerView.contentView.addSubview(priceLabel)
        priceLabel.fillInSuperview(margin: .spacingS)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: openAdButton.topAnchor, constant: -.spacingM),

            openAdButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            openAdButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            progressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingS),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            progressView.heightAnchor.constraint(equalToConstant: 3),

            searchInfoStackView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            searchInfoStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 3 * .spacingXS),
            searchInfoStackView.trailingAnchor.constraint(lessThanOrEqualTo: progressView.trailingAnchor),

            searchIconImageView.widthAnchor.constraint(equalToConstant: storyIconSize),
            searchIconImageView.heightAnchor.constraint(equalToConstant: storyIconSize),

            adTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            adTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant:  -.spacingM),
            adTitleLabel.bottomAnchor.constraint(equalTo: adDetailLabel.topAnchor, constant: -.spacingXS),

            adDetailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            adDetailLabel.bottomAnchor.constraint(equalTo: priceContainerView.topAnchor, constant: -.spacingS),
            adDetailLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.spacingS),

            priceContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            priceContainerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -.spacingM),
            priceContainerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
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

    public func configure(with viewModel: StoryViewModel) {
        self.slides = viewModel.slides
        self.imageUrls = slides.map({ $0.imageUrl })

        currentIndex = 0

        progressView.configure(withNumberOfProgresses: slides.count)

        searchTitleLabel.text = viewModel.title
        openAdButton.setTitle(viewModel.openAdButtonTitle, for: .normal)

        if let storyIconImageUrl = viewModel.iconImageUrl {
            dataSource?.storyView(self, loadImageWithPath: storyIconImageUrl, imageWidth: storyIconSize, completion: { [weak self] image in
                self?.searchIconImageView.image = image
            })
        }
    }

    public func startStory(durationPerSlideInSeconds: Double = 5) {
        progressView.startAnimating(durationPerSlideInSeconds: durationPerSlideInSeconds)
    }

    public func pauseStory() {
        progressView.pauseAnimations()
    }

    public func resumeStory() {
        progressView.resumeAnimations()
    }

    public func updateFavoriteButtonState() {
        guard let isFavorite = dataSource?.storyView(self, slideAtIndexIsFavorite: currentIndex) else { return }
        let favoriteImage = isFavorite ? UIImage(named: .favoriteActive) : UIImage(named: .favoriteDefault)
        favoriteButton.setImage(favoriteImage.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    // MARK: - Private methods

    private func showNextSlide() {
        guard currentIndex + 1 < slides.count else {
            delegate?.storyViewDidFinishStory(self)
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

        adTitleLabel.text = slide.title
        adDetailLabel.text = slide.detailText

        priceLabel.text = slide.price
        priceLabel.isHidden = slide.price == nil

        if let image = downloadedImages[slide.imageUrl] {
            showImage(image)
        } else {
            imageView.image = nil
            downloadImage(withUrl: slide.imageUrl)
        }

        updateFavoriteButtonState()
        predownloadNextImageIfNeeded()
    }

    private func predownloadNextImageIfNeeded() {
        guard let imageUrl = imageUrls[safe: currentIndex + 1] else { return }
        downloadImage(withUrl: imageUrl)
    }

    private func downloadImage(withUrl imageUrl: String) {
        guard !downloadedImages.keys.contains(imageUrl) else { return }
        downloadedImages[imageUrl] = nil

        dataSource?.storyView(self, loadImageWithPath: imageUrl, imageWidth: frame.size.width, completion: { [weak self] image in
            guard let self = self else { return }
            if imageUrl == self.currentImageUrl {
                self.showImage(image)
            }
            self.downloadedImages[imageUrl] = image
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
            delegate?.storyViewDidSelectSearch(self)
        } else if tapLocation.x > frame.size.width / 2 {
            showNextSlide()
        } else {
            showPreviousSlide()
        }
    }

    @objc private func handleDidSelectAd() {
        delegate?.storyViewDidSelectAd(self)
    }

    @objc private func handleSwipeLeft(recognizer: UISwipeGestureRecognizer) {
        delegate?.storyViewDidSelectNextStory(self)
    }
 
    @objc private func handleSwipeRight(recognizer: UISwipeGestureRecognizer) {
        delegate?.storyViewDidSelectPreviousStory(self)
    }

    @objc private func handleFavoriteButtonTap() {
        delegate?.storyView(self, didTapFavoriteButton: favoriteButton, forIndex: currentIndex)
    }

    @objc private func handleShareButtonTap() {
        delegate?.storyViewDidSelectShare(self, forIndex: currentIndex)
    }
}

// MARK: - ProgressViewDelegate

extension StoryView: ProgressViewDelegate {
    func progressViewDidFinishProgress(_ progressView: ProgressView, isLastProgress: Bool) {
        if !isLastProgress {
            currentIndex += 1
        } else {
            delegate?.storyViewDidFinishStory(self)
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
