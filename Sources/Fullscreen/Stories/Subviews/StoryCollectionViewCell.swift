import Foundation
import UIKit
import FinniversKit

protocol StoryCollectionViewCellDataSource: AnyObject {
    var allowPredownloadOfImages: Bool { get }
    func storyCollectionViewCell(_ storyCell: StoryCollectionViewCell, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func storyCollectionViewCell(_ storyCell: StoryCollectionViewCell, slideAtIndexIsFavorite index: Int) -> Bool
}

protocol StoryCollectionViewCellDelegate: AnyObject {
    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, didSelect action: StoryCollectionViewCell.Action)
    func storyCollectionViewCell(_ cell: StoryCollectionViewCell, didShowSlideWithIndex index: Int)
}

class StoryCollectionViewCell: UICollectionViewCell {
    enum Action {
        case showNextStory
        case showPreviousStory
        case navigateToSearch
        case navigateToAd(slideIndex: Int)
        case toggleFavorite(slideIndex: Int, button: UIButton)
        case share(slideIndex: Int)
        case dismiss
    }

    static var imageContainerToContentViewBottomSpacing: CGFloat = openAdButtonHeight + swipeUpIconSize + 2 * swipeUpIconVerticalSpacing

    // MARK: - Subviews

    private lazy var imageView: StoryImageView = {
        let imageView = StoryImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .spacingM
        imageView.clipsToBounds = true
        imageView.backgroundColor = Style.defaultImageBackgroundColor
        return imageView
    }()

    private lazy var progressView: ProgressView = {
        let progressView = ProgressView(withAutoLayout: true)
        progressView.delegate = self
        return progressView
    }()

    private lazy var storyHeaderStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        stackView.alignment = .center
        return stackView
    }()

    private lazy var storyIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = storyIconSize/2
        return imageView
    }()

    private lazy var storyTitleLabel: Label = {
        let label = Label(style: Style.storyTitleStyle, withAutoLayout: true)
        label.textColor = Style.primaryTextColor
        return label
    }()

    private lazy var openAdButton: Button = {
        let button = Button(style: Style.openAdButtonStyle, size: Style.openAdButtonSize, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleDidSelectAd), for: .touchUpInside)
        return button
    }()

    private lazy var swipeUpIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .arrowUp)
        imageView.tintColor = Style.iconTintColor
        return imageView
    }()

    private lazy var slideTitleLabel: Label = {
        let label = Label(style: Style.slideTitleStyle, withAutoLayout: true)
        label.textColor = Style.primaryTextColor
        label.numberOfLines = 2
        return label
    }()

    private lazy var slideDetailLabel: Label = {
        let label = Label(style: Style.slideDetailStyle, withAutoLayout: true)
        label.textColor = Style.primaryTextColor
        return label
    }()

    private lazy var priceContainerView: UIVisualEffectView = {
        let view = UIVisualEffectView(withAutoLayout: true)
        view.effect = UIBlurEffect(style: .systemThinMaterialDark)
        view.layer.cornerRadius = priceLabelHeight / 2
        view.clipsToBounds = true
        return view
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: Style.priceLabelStyle, withAutoLayout: true)
        label.textColor = Style.priceLabelColor
        label.backgroundColor = .clear
        return label
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = Style.iconTintColor
        button.imageEdgeInsets = UIEdgeInsets(vertical: 3 * .spacingXS, horizontal: 3 * .spacingXS)
        button.addTarget(self, action: #selector(handleFavoriteButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = Style.iconTintColor
        button.setImage(UIImage(named: .share).withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(vertical: 3 * .spacingXS, horizontal: 3 * .spacingXS)
        button.addTarget(self, action: #selector(handleShareButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = Style.iconTintColor
        button.setImage(UIImage(named: .close).withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(vertical: .spacingM, horizontal: .spacingM)
        button.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Private properties

    private var slides = [StorySlideViewModel]()
    private var currentIndex = 0
    private var currentImageUrl: String?
    private var wasPreparedForDisplay: Bool = false
    private let storyIconSize: CGFloat = 32
    private let priceLabelHeight: CGFloat = 32
    private let iconSize: CGFloat = 44
    private static var openAdButtonHeight: CGFloat = 44
    private static var swipeUpIconSize: CGFloat = 16
    private static var swipeUpIconVerticalSpacing: CGFloat = .spacingXS
    private typealias Style = StoriesStyling

    private var nextIndex: Int? {
        currentIndex + 1 < slides.count ? currentIndex + 1 : nil
    }

    private var previousIndex: Int? {
        currentIndex - 1 >= 0 ? currentIndex - 1 : nil
    }

    // MARK: - Internal properties

    weak var dataSource: StoryCollectionViewCellDataSource?
    weak var delegate: StoryCollectionViewCellDelegate?
    private(set) var indexPath: IndexPath?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(progressView)
        contentView.addSubview(storyHeaderStackView)
        contentView.addSubview(swipeUpIconImageView)
        contentView.addSubview(openAdButton)
        contentView.addSubview(slideTitleLabel)
        contentView.addSubview(slideDetailLabel)
        contentView.addSubview(priceContainerView)
        contentView.addSubview(shareButton)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(closeButton)

        storyHeaderStackView.addArrangedSubviews([storyIconImageView, storyTitleLabel])

        priceContainerView.contentView.addSubview(priceLabel)
        priceLabel.fillInSuperview(margin: .spacingS)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: swipeUpIconImageView.topAnchor, constant: -Self.swipeUpIconVerticalSpacing),

            openAdButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            openAdButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            openAdButton.heightAnchor.constraint(equalToConstant: Self.openAdButtonHeight),

            swipeUpIconImageView.centerXAnchor.constraint(equalTo: openAdButton.centerXAnchor),
            swipeUpIconImageView.bottomAnchor.constraint(equalTo: openAdButton.topAnchor, constant: -Self.swipeUpIconVerticalSpacing),
            swipeUpIconImageView.heightAnchor.constraint(equalToConstant: Self.swipeUpIconSize),
            swipeUpIconImageView.widthAnchor.constraint(equalToConstant: Self.swipeUpIconSize),

            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),
            progressView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: .spacingS),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingS),
            progressView.heightAnchor.constraint(equalToConstant: 3),

            storyHeaderStackView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            storyHeaderStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 3 * .spacingXS),
            storyHeaderStackView.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor),

            storyIconImageView.widthAnchor.constraint(equalToConstant: storyIconSize),
            storyIconImageView.heightAnchor.constraint(equalToConstant: storyIconSize),

            closeButton.centerYAnchor.constraint(equalTo: storyHeaderStackView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: iconSize),
            closeButton.widthAnchor.constraint(equalToConstant: iconSize),

            slideTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            slideTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant:  -.spacingM),
            slideTitleLabel.bottomAnchor.constraint(equalTo: slideDetailLabel.topAnchor, constant: -.spacingXS),

            slideDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            slideDetailLabel.bottomAnchor.constraint(equalTo: priceContainerView.topAnchor, constant: -.spacingS),
            slideDetailLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.spacingS),

            priceContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            priceContainerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -.spacingM),
            priceContainerView.trailingAnchor.constraint(lessThanOrEqualTo: favoriteButton.leadingAnchor),
            priceContainerView.heightAnchor.constraint(equalToConstant: priceLabelHeight),

            favoriteButton.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: priceContainerView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: iconSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: iconSize),

            shareButton.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor),
            shareButton.centerYAnchor.constraint(equalTo: favoriteButton.centerYAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: iconSize),
            shareButton.heightAnchor.constraint(equalToConstant: iconSize),
        ])

        setupGestureRecognizers()
    }

    private func setupGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))

        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleDidSelectAd))
        swipeUpGestureRecognizer.direction = .up
        addGestureRecognizer(swipeUpGestureRecognizer)

        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:))))
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.reset()
        imageView.backgroundColor = Style.defaultImageBackgroundColor
        imageView.image = nil
        storyIconImageView.image = nil
        slides = []
        indexPath = nil
        wasPreparedForDisplay = false
        currentIndex = 0
        delegate = nil
        dataSource = nil
        currentImageUrl = nil
    }

    // MARK: - Internal methods

    func configure(with story: StoryViewModel, indexPath: IndexPath) {
        self.indexPath = indexPath

        storyTitleLabel.text = story.title
        openAdButton.setTitle(story.openAdButtonTitle, for: .normal)

        if let storyIconImageUrl = story.iconImageUrl, !storyIconImageUrl.isEmpty {
            dataSource?.storyCollectionViewCell(self, loadImageWithPath: storyIconImageUrl, imageWidth: storyIconSize, completion: { [weak self] image in
                self?.storyIconImageView.image = image ?? UIImage(named: .noImage)
            })
        } else {
            storyIconImageView.image = UIImage(named: .noImage)
            storyIconImageView.backgroundColor = .milk
        }
    }

    func configue(with slides: [StorySlideViewModel], startIndex: Int) {
        self.slides = slides

        showSlide(at: startIndex)
        progressView.configure(withNumberOfProgresses: slides.count)
        progressView.setActiveIndex(startIndex, startAnimations: false)

        if wasPreparedForDisplay {
            startStory()
        }
    }

    func prepareForDisplay() {
        wasPreparedForDisplay = true
        if !slides.isEmpty {
            startStory()
            delegate?.storyCollectionViewCell(self, didShowSlideWithIndex: currentIndex)
        }
    }

    func pauseStory() {
        progressView.pauseAnimations()
    }

    func resumeStory() {
        progressView.resumeOngoingAnimationsIfAny()
    }

    func updateFavoriteButtonState() {
        guard let isFavorite = dataSource?.storyCollectionViewCell(self, slideAtIndexIsFavorite: currentIndex) else { return }
        let favoriteImage = isFavorite ? UIImage(named: .favoriteActive) : UIImage(named: .favoriteDefault)
        favoriteButton.setImage(favoriteImage.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    // MARK: - Private methods

    private func startStory() {
        progressView.startAnimating(durationPerProgressInSeconds: 5)
    }

    private func showNextSlide() {
        guard let nextIndex = nextIndex else {
            delegate?.storyCollectionViewCell(self, didSelect: .showNextStory)
            return
        }
        progressView.setActiveIndex(nextIndex, startAnimations: true)
        showSlide(at: nextIndex)
    }

    private func showPreviousSlide() {
        guard let previousIndex = previousIndex else {
            delegate?.storyCollectionViewCell(self, didSelect: .showPreviousStory)
            return
        }
        progressView.setActiveIndex(previousIndex, startAnimations: true)
        showSlide(at: previousIndex)
    }

    private func showSlide(at index: Int) {
        guard let slide = slides[safe: index] else { return }

        currentIndex = index
        slideTitleLabel.text = slide.title
        slideDetailLabel.text = slide.detailText
        priceLabel.text = slide.price
        priceContainerView.isHidden = slide.price == nil

        updateFavoriteButtonState()
        configureImage(forSlide: slide)
        predownloadNextImageIfPossible()

        if wasPreparedForDisplay {
            delegate?.storyCollectionViewCell(self, didShowSlideWithIndex: index)
        }
    }

    private func configureImage(forSlide slide: StorySlideViewModel) {
        currentImageUrl = slide.imageUrl

        guard let imageUrl = slide.imageUrl, !imageUrl.isEmpty else {
            imageView.configureWithPlaceholderImage()
            return
        }

        imageView.image = nil
        downloadImage(withUrl: imageUrl)
    }

    private func predownloadNextImageIfPossible() {
        guard
            dataSource?.allowPredownloadOfImages ?? false,
            let nextIndex = nextIndex,
            let nextImageUrl = slides[safe: nextIndex]?.imageUrl,
            !nextImageUrl.isEmpty
        else { return }

        downloadImage(withUrl: nextImageUrl)
    }

    private func downloadImage(withUrl imageUrl: String) {
        dataSource?.storyCollectionViewCell(self, loadImageWithPath: imageUrl, imageWidth: UIScreen.main.bounds.width, completion: { [weak self] image in
            guard let self = self else { return }
            if imageUrl == self.currentImageUrl {
                self.imageView.configure(withImage: image)
            }
        })
    }

    // MARK: - Actions

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)

        if storyHeaderStackView.frame.contains(tapLocation) {
            delegate?.storyCollectionViewCell(self, didSelect: .navigateToSearch)
        } else if tapLocation.x > frame.size.width / 2 {
            showNextSlide()
        } else {
            showPreviousSlide()
        }
    }

    @objc private func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            progressView.pauseAnimations()
        case .ended, .cancelled:
            progressView.resumeOngoingAnimationsIfAny()
        default:
            break
        }
    }

    @objc private func handleDidSelectAd() {
        delegate?.storyCollectionViewCell(self, didSelect: .navigateToAd(slideIndex: currentIndex))
    }

    @objc private func handleFavoriteButtonTap() {
        delegate?.storyCollectionViewCell(self, didSelect: .toggleFavorite(slideIndex: currentIndex, button: favoriteButton))
    }

    @objc private func handleShareButtonTap() {
        delegate?.storyCollectionViewCell(self, didSelect: .share(slideIndex: currentIndex))
    }

    @objc private func handleCloseButtonTap() {
        delegate?.storyCollectionViewCell(self, didSelect: .dismiss)
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
