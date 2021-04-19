import UIKit
import FinniversKit

public protocol SearchDropdownContainerViewDelegate: AnyObject {
    func searchDropdownContainerViewDidSelectActionButton(_ view: SearchDropdownContainerView)
}

public class SearchDropdownContainerView: UIView {

    // MARK: - Private properties

    private weak var delegate: SearchDropdownContainerViewDelegate?
    private let contentView: UIView
    private lazy var titleLabel = Label(style: .title3Strong, withAutoLayout: true)

    private lazy var actionButton: Button = {
        let button = Button(style: .flat, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: 0, withAutoLayout: true)
        stackView.alignment = .center
        stackView.addArrangedSubviews([titleLabel, actionButton])
        return stackView
    }()

    // MARK: - Init

    public init(contentView: UIView, delegate: SearchDropdownContainerViewDelegate? = nil, withAutoLayout: Bool = false) {
        self.contentView = contentView
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary
        addSubview(headerStackView)
        addSubview(contentView)

        let innerLayoutGuide = UILayoutGuide()
        addLayoutGuide(innerLayoutGuide)

        NSLayoutConstraint.activate([
            innerLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            innerLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            innerLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            innerLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),

            headerStackView.topAnchor.constraint(equalTo: innerLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: innerLayoutGuide.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: innerLayoutGuide.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: .spacingS),
            contentView.leadingAnchor.constraint(equalTo: innerLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: innerLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: innerLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(title: String, buttonTitle: String?) {
        titleLabel.text = title

        if let buttonTitle = buttonTitle {
            actionButton.setTitle(buttonTitle, for: .normal)
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }

    // MARK: - Actions

    @objc private func handleActionButtonTap() {
        delegate?.searchDropdownContainerViewDidSelectActionButton(self)
    }
}
