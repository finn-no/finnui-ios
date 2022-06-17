import Combine
import FinniversKit
import UIKit

public final class TJTAccordionViewModel: ObservableObject {
    let title: String
    let icon: UIImage
    @Published var isExpanded: Bool

    public init(title: String, icon: UIImage, isExpanded: Bool) {
        self.title = title
        self.icon = icon
        self.isExpanded = isExpanded
    }
}

public class TJTAccordionView: UIStackView {
    private let viewModel: TJTAccordionViewModel
    private var cancellables: Set<AnyCancellable> = []

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
        return chevron
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = UIColor(hex: "#E1E6EE")
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
        viewModel
            .$isExpanded
            .sink { [weak self] isExpanded in
                guard let strongSelf = self else { return }
                let transform = CGAffineTransform.identity

                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: {
                        if isExpanded {
                            strongSelf.chevron.transform = transform.rotated(by: .pi * 180)
                            strongSelf.chevron.transform = transform.rotated(by: .pi * -1)
                        } else {
                            strongSelf.chevron.transform = transform
                        }

                        strongSelf.contentContainerView.alpha = isExpanded ? 1 : 0
                        strongSelf.separatorStackView.alpha = isExpanded ? 1 : 0
                        strongSelf.contentContainerView.isHidden = !isExpanded
                        strongSelf.separatorStackView.isHidden = !isExpanded
                        strongSelf.containerEnclosingView.layoutIfNeeded()
                    }
                )
            }
            .store(in: &cancellables)
    }

    @objc
    private func didTapHeader() {
        viewModel.isExpanded = !viewModel.isExpanded
    }
}
