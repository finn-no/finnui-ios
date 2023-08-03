import FinniversKit
import UIKit

public class FiksFerdigInfoBaseView: UIStackView {
    private let viewModel: FiksFerdigInfoBaseViewModel

    private lazy var headerStackView: UIStackView = {
        let header = UIStackView(axis: .horizontal)
        header.spacing = .spacingM
        header.directionalLayoutMargins = .init(
            top: .spacingM,
            leading: .spacingM,
            bottom: .spacingL,
            trailing: .spacingM
        )
        header.alignment = .center
        header.isLayoutMarginsRelativeArrangement = true
        return header
    }()

    private lazy var headerIcon: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textPrimary
        return imageView
    }()

    private lazy var headerTitle: Label = {
        let label = Label(style: .bodyStrong)
        label.numberOfLines = 0
        return label
    }()

    private lazy var contentContainerView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.directionalLayoutMargins = .init(
            top: 0,
            leading: .spacingM,
            bottom: .spacingM,
            trailing: .spacingM
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    public init(
        viewModel: FiksFerdigInfoBaseViewModel,
        withAutolayout: Bool = false
    ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutolayout
        setup()
        decorate()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addViewToContentView(_ view: UIView, withSpacing spacing: CGFloat = 0) {
        contentContainerView.addArrangedSubview(view)
        contentContainerView.setCustomSpacing(spacing, after: view)
    }

    private func setup() {
        axis = .vertical
        layer.masksToBounds = true

        headerStackView.addArrangedSubviews([
            headerIcon,
            headerTitle
        ])
        addArrangedSubview(headerStackView)

        addArrangedSubview(contentContainerView)

        NSLayoutConstraint.activate([
            headerIcon.widthAnchor.constraint(equalToConstant: 24),
            headerIcon.heightAnchor.constraint(equalToConstant: 24),
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor)
        ])
    }

    private func decorate() {
        headerTitle.text = viewModel.title
        headerIcon.image = viewModel.icon
    }
}
