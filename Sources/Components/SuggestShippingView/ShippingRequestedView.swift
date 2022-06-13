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

    public static func create(with viewModel: ShippingRequestedViewModel) -> ShippingRequestedView {
        let view = ShippingRequestedView(withAutoLayout: true)
        view.setup()
        view.decorate(with: viewModel)
        return view
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
