import UIKit
import FinniversKit

public protocol FadedExpandViewDelegate: AnyObject {
    func fadedExpandViewDidSelectExpandButton(_ view: FadedExpandView)
}

public class FadedExpandView: UIView {

    // MARK: - Private properties

    private weak var delegate: FadedExpandViewDelegate?

    private var gradientColors: [CGColor] = [
        UIColor.white.withAlphaComponent(0).cgColor,
        UIColor.white.withAlphaComponent(0).cgColor,
        UIColor.bgPrimary.cgColor,
        UIColor.bgPrimary.cgColor
    ]

    private lazy var expandButton: Button = {
        let button = Button(style: .default, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = gradientColors
        layer.locations = [0, 0.1, 0.6, 1.0]
        return layer
    }()

    // MARK: - Init

    public init(
        contentView: UIView,
        verticalMargin: CGFloat = 0,
        buttonTitle: String,
        delegate: FadedExpandViewDelegate,
        withAutoLayout: Bool
    ) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        expandButton.setTitle(buttonTitle, for: .normal)
        setup(contentView: contentView, verticalMargin: verticalMargin)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(contentView: UIView, verticalMargin: CGFloat) {
        addSubview(contentView)
        addSubview(expandButton)
        layer.insertSublayer(gradientLayer, below: expandButton.layer)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: verticalMargin),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -verticalMargin),

            expandButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            expandButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),
            expandButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.spacingM),

            heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = bounds
    }

    // MARK: - Actions

    @objc private func expandButtonTapped() {
        delegate?.fadedExpandViewDidSelectExpandButton(self)
    }
}
