import Foundation
import UIKit
import FinniversKit

protocol FeedbackCollectionViewCellDelegate: AnyObject {
    func feedbackCollectionViewCell(_ feedbackCollectionViewCell: FeedbackCollectionViewCell, didSelectAction action: FeedbackCollectionViewCell.Action)
    func feedbackCollectionViewCell(_ feedbackCollectionViewCell: FeedbackCollectionViewCell, didSelectOptionWithIndex index: Int)
}

class FeedbackCollectionViewCell: UICollectionViewCell {
    enum Action {
        case next
        case previous
        case dismiss
    }

    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .nmpBrandColorPrimary
        view.layer.cornerRadius = .spacingM
        view.clipsToBounds = true
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = StoriesStyling.iconTintColor
        button.setImage(UIImage(named: .close).withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(vertical: .spacingM, horizontal: .spacingM)
        button.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: StoriesStyling.feedbackTitleStyle, withAutoLayout: true)
        label.textColor = StoriesStyling.primaryTextColor
        label.numberOfLines = 0
        return label
    }()

    private lazy var optionsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var disclaimerLabel: Label = {
        let label = Label(style: StoriesStyling.feedbackDisclaimerStyle, withAutoLayout: true)
        label.textColor = StoriesStyling.primaryTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var successLabel: Label = {
        let label = Label(style: StoriesStyling.feedbackSuccessLabelStyle, withAutoLayout: true)
        label.textColor = StoriesStyling.primaryTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private var optionButtons = [OptionButton]()

    weak var delegate: FeedbackCollectionViewCellDelegate?

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
        contentView.addSubview(containerView)

        let backgroundFigureLeft = createBackgroundImageView(with: UIImage(named: .backgroundFigureLeft))
        let backgroundFigureTop = createBackgroundImageView(with: UIImage(named: .backgroundFigureTop))
        let backgroundFigureRight = createBackgroundImageView(with: UIImage(named: .backgroundFigureRight))

        containerView.addSubview(backgroundFigureLeft)
        containerView.addSubview(backgroundFigureTop)
        containerView.addSubview(backgroundFigureRight)

        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(optionsStackView)
        containerView.addSubview(disclaimerLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StoryCollectionViewCell.imageContainerToContentViewBottomSpacing),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),

            backgroundFigureLeft.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundFigureLeft.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50, priority: .defaultLow),

            backgroundFigureTop.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundFigureTop.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -70),

            backgroundFigureRight.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -70),
            backgroundFigureRight.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .spacingM),
            titleLabel.topAnchor.constraint(equalTo: backgroundFigureLeft.bottomAnchor, constant: .spacingXL, priority: .defaultLow),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.spacingM),

            optionsStackView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .spacingM),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.spacingM),
            optionsStackView.bottomAnchor.constraint(equalTo: disclaimerLabel.topAnchor, constant: -60),

            disclaimerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .spacingM),
            disclaimerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.spacingM),
            disclaimerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.spacingM),
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }

    // MARK: - Internal methods

    func configure(with viewModel: StoryFeedbackViewModel) {
        titleLabel.text = viewModel.title
        disclaimerLabel.text = viewModel.disclaimerText
        successLabel.text = viewModel.feedbackGivenText

        optionButtons.forEach({ $0.removeFromSuperview() })
        optionButtons.removeAll()

        for feedbackOption in viewModel.feedbackOptions {
            let button = OptionButton(title: feedbackOption)
            optionButtons.append(button)
            optionsStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }

    // MARK: - Private methods

    @objc private func optionTapped(sender: UIButton) {
        guard
            let optionButton = sender as? OptionButton,
            let index = optionButtons.firstIndex(of: optionButton)
        else { return }

        delegate?.feedbackCollectionViewCell(self, didSelectOptionWithIndex: index)

        optionsStackView.isHidden = true
        titleLabel.isHidden = true
        containerView.addSubview(successLabel)

        NSLayoutConstraint.activate([
            successLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            successLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            successLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            guard let self = self else { return }
            self.delegate?.feedbackCollectionViewCell(self, didSelectAction: .dismiss)
        })
    }

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)

        if tapLocation.x > frame.size.width / 2 {
            delegate?.feedbackCollectionViewCell(self, didSelectAction: .next)
        } else {
            delegate?.feedbackCollectionViewCell(self, didSelectAction: .previous)
        }
    }

    @objc private func handleCloseButtonTap() {
        delegate?.feedbackCollectionViewCell(self, didSelectAction: .dismiss)
    }

    private func createBackgroundImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = image
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }
}

private class OptionButton: UIButton {
    private let highlightedColor: UIColor = .white.withAlphaComponent(0.2)

    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .checkMark)
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedColor : .nmpBrandColorPrimary
            checkImageView.isHidden = !isHighlighted
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: 57)
    }

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        titleLabel?.font = .title3Strong
        backgroundColor = .nmpBrandColorPrimary
        layer.cornerRadius = 16
        titleEdgeInsets = UIEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0)
        contentHorizontalAlignment = .leading

        addSubview(checkImageView)

        NSLayoutConstraint.activate([
            checkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
