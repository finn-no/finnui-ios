import Foundation
import UIKit

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

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -68)
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)

        // if button.frame.contains(tapLocation) etc.

        if tapLocation.x > frame.size.width / 2 {
            delegate?.feedbackCollectionViewCell(self, didSelectAction: .next)
        } else {
            delegate?.feedbackCollectionViewCell(self, didSelectAction: .previous)
        }
    }
}
