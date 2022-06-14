import FinniversKit

public final class ShippingRequestedView: UIView {
    private let containerView = UIStackView(axis: .vertical)

    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .checkMarkCircle))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var title: Label = {
        let label = Label(style: .captionStrong)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var message: Label = {
        let label = Label(style: .caption)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    public init(viewModel: ShippingRequestedViewModel, withAutoLayout: Bool = false) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
        decorate(with: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.sardine.cgColor
        layer.cornerRadius = 3

        addSubview(containerView)
        containerView.fillInSuperview(margin: 16)
        containerView.addArrangedSubview(checkImageView)
        containerView.setCustomSpacing(12, after: checkImageView)
        containerView.addArrangedSubviews([
            title,
            message
        ])
    }

    private func decorate(with viewModel: ShippingRequestedViewModel) {
        title.text = viewModel.title
        message.text = viewModel.message
    }
}
