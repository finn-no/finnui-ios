import UIKit
import FinniversKit

class ViewingInfoView: UIView {

    // MARK: - Private properties

    private lazy var titleLabel = Label(style: .detailStrong, withAutoLayout: true)

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .clockSmall)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(iconImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingS),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 4
    }

    // MARK: - Internal methods

    func configure(with title: String, textColor: UIColor, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        titleLabel.textColor = textColor
        iconImageView.tintColor = textColor
        titleLabel.text = title
    }
}
