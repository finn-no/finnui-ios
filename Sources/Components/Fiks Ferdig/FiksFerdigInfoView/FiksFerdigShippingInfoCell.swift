import UIKit
import FinniversKit

public final class FiksFerdigShippingInfoCell: UIStackView {
    private let viewModel: FiksFerdigShippingInfoCellViewModel

    private let providerLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private let messageLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private var providerIcon: UIImage? {
        switch viewModel.provider {
        case .heltHjem:
            return UIImage(named: .tjtHelthjemIcon)
        case .postnord:
            return UIImage(named: .tjtPostnordIcon)
        case .posten:
            return UIImage(named: .tjtPostenIcon)
        default:
            return nil
        }
    }

    private let providerIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textContainerStackView = UIStackView(axis: .vertical)

    public init(viewModel: FiksFerdigShippingInfoCellViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.axis = .horizontal
        self.spacing = .spacingS

        providerIconView.image = providerIcon
        providerLabel.text = viewModel.providerName
        messageLabel.text = viewModel.message

        providerLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        providerIconView.setContentHuggingPriority(.required, for: .horizontal)
        providerIconView.setContentCompressionResistancePriority(.required, for: .horizontal)

        textContainerStackView.addArrangedSubviews([
            providerLabel,
            messageLabel
        ])

        self.addArrangedSubviews([
            providerIconView,
            textContainerStackView
        ])
    }
}
