//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

final class TagCloudCell: UICollectionViewCell {

    // MARK: - Static properties

    static let height: CGFloat = 41
    static let iconSize: CGFloat = 24
    static let textFont = UIFont.bodyRegular

    static func width(for viewModel: TagCloudCellViewModel) -> CGFloat {
        var width: CGFloat = .spacingS * 2
        if viewModel.iconUrl != nil {
            width += iconSize
        }
        width += viewModel.text.width(withConstrainedHeight: height, font: textFont) + .spacingM
        return width
    }

    // MARK: - Internal properties

    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            iconView.dataSource = remoteImageViewDataSource
        }
    }

    // MARK: - Private properties

    private var showShadow = false

    private lazy var iconView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        view.tintColor = .white
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = TagCloudCell.textFont
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconView, textLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = .spacingS
        return stackView
    }()

    private lazy var stackViewLeading = stackView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: .spacingS
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        dropShadow(color: .black, opacity: showShadow ? 0.1 : 0, offset: CGSize(width: 0, height: 2), radius: 4)
    }

    // MARK: - Setup

    func configure(with viewModel: TagCloudCellViewModel) {
        contentView.backgroundColor = viewModel.backgroundColor

        stackViewLeading.constant = viewModel.iconUrl == nil ? .spacingM : .spacingS
        textLabel.textColor = viewModel.foregroundColor
        textLabel.text = viewModel.text
        textLabel.sizeToFit()

        iconView.isHidden = viewModel.iconUrl == nil
        iconView.tintColor = viewModel.foregroundColor
        showShadow = viewModel.showShadow

        if let iconUrl = viewModel.iconUrl {
            iconView.loadImage(for: iconUrl, imageWidth: TagCloudCell.iconSize, modify: {
                $0?.withRenderingMode(.alwaysTemplate)
            })
        }
    }

    private func setup() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackViewLeading,
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            iconView.widthAnchor.constraint(equalToConstant: TagCloudCell.iconSize),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),

            textLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
    }
}
