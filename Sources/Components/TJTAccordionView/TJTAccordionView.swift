import Combine
import FinniversKit
import UIKit

public protocol TJTAccordionViewModelDelegate: AnyObject {
    func didChangeExpandedState(isExpanded: Bool)
}

public final class TJTAccordionViewModel: ObservableObject {
    public let title: String
    public let icon: UIImage
    @Published public var isExpanded: Bool {
        didSet {
            delegate?.didChangeExpandedState(isExpanded: isExpanded)
        }
    }

    public weak var delegate: TJTAccordionViewModelDelegate?

    public init(title: String, icon: UIImage, isExpanded: Bool) {
        self.title = title
        self.icon = icon
        self.isExpanded = isExpanded
    }
}

public class TJTAccordionView: UIStackView {
    private let viewModel: TJTAccordionViewModel
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
        label.textColor = .textPrimary
        return label
    }()

    private lazy var chevron: UIImageView = {
        let bundle = Bundle(for: Label.self)
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

    public init(viewModel: TJTAccordionViewModel, withAutolayout: Bool = false) {
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

        headerIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        headerIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        chevron.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        headerStackView.addArrangedSubviews([
            headerIcon,
            headerTitle,
            chevron
        ])
        addArrangedSubview(headerStackView)

        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorStackView.addArrangedSubview(separatorView)
        addArrangedSubview(separatorStackView)

        containerEnclosingView.addArrangedSubviews([
            separatorStackView,
            contentContainerView
        ])
        addArrangedSubview(containerEnclosingView)

        NSLayoutConstraint.activate([
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
