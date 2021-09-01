//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

final class ExploreDetailHeroView: UIView {

    // MARK: - Internal properties

    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = remoteImageViewDataSource
        }
    }

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .accentSecondaryBlue
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detail
        label.textColor = .white
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.dropShadow(color: .black, opacity: 0.25, offset: CGSize(width: 0, height: 4), radius: 2)
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .title1
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.dropShadow(color: .black, opacity: 0.25, offset: CGSize(width: 0, height: 4), radius: 2)
        return label
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
        return layer
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Setup

    func configure(withTitle title: String, subtitle: String, imageUrl: String?) {
        if let imageUrl = imageUrl {
            imageView.loadImage(for: imageUrl, imageWidth: bounds.size.width)
        }

        titleLabel.text = title
        titleLabel.sizeToFit()

        subtitleLabel.setText(subtitle, withCharacterSpacing: 4)
        subtitleLabel.sizeToFit()
    }

    private func setup() {
        let stackView = UIStackView(arrangedSubviews: [subtitleLabel, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = .spacingXS
        stackView.setCustomSpacing(.spacingS, after: titleLabel)

        addSubview(imageView)
        layer.addSublayer(gradientLayer)
        addSubview(stackView)

        imageView.fillInSuperview()

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),

            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
}

// MARK: - Private extensions

private extension UILabel {
    func setText(_ text: String, withCharacterSpacing spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
}
