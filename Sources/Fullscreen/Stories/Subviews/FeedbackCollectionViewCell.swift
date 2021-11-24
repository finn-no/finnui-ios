import Foundation
import UIKit
import FinniversKit

protocol FeedbackCollectionViewCellDelegate: AnyObject {
    func feedbackCollectionViewCell(_ feedbackCollectionViewCell: FeedbackCollectionViewCell, didSelectAction action: FeedbackCollectionViewCell.Action)
}

class FeedbackCollectionViewCell: UICollectionViewCell {
    enum Action {
        case next
        case previous
        case dismiss
    }

    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .primaryBlue
        view.layer.cornerRadius = .spacingM
        view.clipsToBounds = true
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .milk
        button.setImage(UIImage(named: .close).withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(vertical: .spacingM, horizontal: .spacingM)
        button.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title2, withAutoLayout: true)
        label.textColor = .milk
        label.numberOfLines = 0
        return label
    }()

    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        return stackView
    }()

    private lazy var disclaimerLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .milk
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private var optionButtons = [OptionButton]()

    weak var delegate: FeedbackCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(containerView)

        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(optionsStackView)
        containerView.addSubview(disclaimerLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -68), // This constant aligns the background with the image background for stories.

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .spacingM),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.spacingM),

            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .spacingM),
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.spacingM),
            optionsStackView.bottomAnchor.constraint(equalTo: disclaimerLabel.topAnchor, constant: -60),

            disclaimerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .spacingM),
            disclaimerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.spacingM),
            disclaimerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.spacingM),
        ])

        disclaimerLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        optionsStackView.setContentHuggingPriority(.defaultHigh - 1, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }

    func configure(with viewModel: StoryFeedbackViewModel) {
        titleLabel.text = viewModel.title
        disclaimerLabel.text = viewModel.disclaimerText

        optionButtons.forEach({ $0.removeFromSuperview() })
        optionButtons.removeAll()

        for feedbackOption in viewModel.feedbackOptions {
            let button = OptionButton(option: feedbackOption)
            optionButtons.append(button)
            optionsStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }

    @objc private func optionTapped(sender: UIButton) {
        guard let optionButton = sender as? OptionButton else { return }
        print("OPTION \(optionButton.id) TAPPED")
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
}

private class OptionButton: UIButton {
    var id: Int
    private let highlightedColor: UIColor = .white.withAlphaComponent(0.2)

    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .arrowUp)
        imageView.isHidden = true
        return imageView
    }()

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedColor : .primaryBlue
            checkImageView.isHidden = !isHighlighted
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: 57)
    }

    init(option: StoryFeedbackViewModel.FeedbackOption) {
        self.id = option.id
        super.init(frame: .zero)

        setTitle(option.title, for: .normal)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        titleLabel?.font = .title3Strong
        backgroundColor = .primaryBlue
        layer.cornerRadius = 16
        titleEdgeInsets = UIEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0)
        contentHorizontalAlignment = .leading

        addSubview(checkImageView)
        NSLayoutConstraint.activate([
            checkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
