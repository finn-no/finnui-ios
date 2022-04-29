import UIKit
import FinniversKit

public protocol ShippingPackageSizeViewDelegate: AnyObject {
    func shippingPackageSizeView(_ view: ShippingPackageSizeView, didSelectItemModel itemModel: ShippingPackageSizeItemModel)
    func shippingPackageSizeViewDidRemoveSelection(_ view: ShippingPackageSizeView)
}

public class ShippingPackageSizeView: UIView {

    // MARK: - Public properties

    public weak var delegate: ShippingPackageSizeViewDelegate?

    // MARK: - Private properties

    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var helpTextLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentStackView.addArrangedSubviews([buttonsStackView, helpTextLabel])
        addSubview(contentStackView)
        contentStackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with itemModels: [ShippingPackageSizeItemModel]) {
        buttonsStackView.removeArrangedSubviews()

        let buttonViews = itemModels.map { itemModel -> ShippingPackageSizeButton in
            let view = ShippingPackageSizeButton(viewModel: itemModel, withAutoLayout: true)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleButtonTap))
            view.addGestureRecognizer(gestureRecognizer)
            return view
        }

        buttonsStackView.addArrangedSubviews(buttonViews)
        updateHelpTextLabel(with: itemModels.first(where: { $0.isInitiallySelected })?.helpText)
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        buttonsStackView.spacing = frame.width / 32
    }

    // MARK: - Private methods

    private func updateHelpTextLabel(with string: String?) {
        helpTextLabel.isHidden = string == nil
        helpTextLabel.text = string
    }

    // MARK: - Actions

    @objc private func handleButtonTap(_ gestureRecognizer: UIGestureRecognizer) {
        guard let view = gestureRecognizer.view as? ShippingPackageSizeButton else { return }

        if view.isSelected {
            view.isSelected = false
            updateHelpTextLabel(with: nil)
            delegate?.shippingPackageSizeViewDidRemoveSelection(self)
        } else {
            buttonsStackView.arrangedSubviews.compactMap { $0 as? ShippingPackageSizeButton }.forEach { buttonView in
                buttonView.isSelected = buttonView == view
            }
            updateHelpTextLabel(with: view.viewModel.helpText)
            delegate?.shippingPackageSizeView(self, didSelectItemModel: view.viewModel)
        }
    }
}
