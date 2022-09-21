import Combine
import FinniversKit
import UIKit

public class FiksFerdigAccordionView: UIStackView {
    private let viewModel: FiksFerdigAccordionViewModel
    private var cancellable: AnyCancellable?

    private lazy var headerStackView: UIStackView = {
        let header = UIStackView(axis: .horizontal)
        header.spacing = .spacingM
        header.directionalLayoutMargins = .init(
            top: .spacingM,
            leading: .spacingM,
            bottom: .spacingM,
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

    private lazy var chevron: UIImageView = {
        let image = UIImage(systemName: "chevron.down")
        let chevron = UIImageView(image: image)
        chevron.contentMode = .scaleAspectFit
        chevron.tintColor = .textPrimary
        return chevron
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .separator
        return view
    }()

    private lazy var separatorStackView: UIStackView = {
        let separatorStackView = UIStackView(axis: .horizontal)
        separatorStackView.directionalLayoutMargins = .init(
            top: .zero,
            leading: .spacingM + 24 + .spacingM,
            bottom: .zero,
            trailing: .zero
        )
        separatorStackView.isLayoutMarginsRelativeArrangement = true
        return separatorStackView
    }()

    private lazy var contentContainerView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.directionalLayoutMargins = .init(
            top: .spacingM,
            leading: .spacingM,
            bottom: .spacingM,
            trailing: .spacingM
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var containerEnclosingView = UIStackView(axis: .vertical)

    public init(viewModel: FiksFerdigAccordionViewModel, withAutolayout: Bool = false) {
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
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentContainerView.addArrangedSubview(view)
        contentContainerView.setCustomSpacing(spacing, after: view)
    }

    private func setup() {
        axis = .vertical
        layer.masksToBounds = true

        chevron.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        headerStackView.addArrangedSubviews([
            headerIcon,
            headerTitle,
            chevron
        ])
        addArrangedSubview(headerStackView)

        separatorStackView.addArrangedSubview(separatorView)
        addArrangedSubview(separatorStackView)

        containerEnclosingView.addArrangedSubviews([
            separatorStackView,
            contentContainerView
        ])
        addArrangedSubview(containerEnclosingView)

        NSLayoutConstraint.activate([
            headerIcon.widthAnchor.constraint(equalToConstant: 24),
            headerIcon.heightAnchor.constraint(equalToConstant: 24),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor)
        ])

        headerStackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerStackView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func decorate() {
        headerTitle.text = viewModel.title
        headerIcon.image = viewModel.icon
        cancellable = viewModel
            .$isExpanded
            .sink(receiveValue: { [weak self] isExpanded in
                self?.updateState(isExpanded: isExpanded)
            })
    }

    private func updateState(isExpanded: Bool) {
        let transform = CGAffineTransform.identity
        if isExpanded {
            chevron.transform = transform.rotated(by: .pi * 180)
            chevron.transform = transform.rotated(by: .pi * -1)
        } else {
            chevron.transform = transform
        }

        contentContainerView.alpha = isExpanded ? 1 : 0
        separatorStackView.alpha = isExpanded ? 1 : 0
        contentContainerView.isHidden = !isExpanded
        separatorStackView.isHidden = !isExpanded
        containerEnclosingView.layoutIfNeeded()
    }

    @objc
    private func didTapHeader() {
        viewModel.isExpanded.toggle()
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var separator = dynamicColor(defaultColor: .sardine, darkModeColor: .darkSardine)
}
