import UIKit
import FinniversKit

protocol AgentProfileViewDelegate: AnyObject {
    func agentProfileViewDidSelectPhoneButton(_ view: AgentProfileView)
}

class AgentProfileView: UIView {

    // MARK: - Internal properties

    weak var delegate: AgentProfileViewDelegate?

    // MARK: - Private properties

    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
    private lazy var contactStackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
    private lazy var titleLabel = Label.create(style: .title3Strong)
    private lazy var nameLabel = Label.create(style: .bodyStrong)
    private lazy var jobTitleLabel = Label.create(style: .detail)
    private lazy var imageSize = CGSize(width: 96, height: 96)

    private lazy var phoneButton: Button = {
        let button = Button(style: .link, withAutoLayout: true)
        button.contentHorizontalAlignment = .left
        button.isHidden = true
        button.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var remoteImageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()

    // MARK: - Init

    init(delegate: AgentProfileViewDelegate, withAutoLayout: Bool) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        textStackView.addArrangedSubviews([nameLabel, jobTitleLabel, phoneButton])
        textStackView.setCustomSpacing(.spacingM, after: jobTitleLabel)

        addSubview(titleLabel)
        addSubview(remoteImageView)
        addSubview(textStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            remoteImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            remoteImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            remoteImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            remoteImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageSize.width),

            textStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            textStackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .spacingM),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    // MARK: - Internal methods

    func configure(with model: AgentProfileModel, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        titleLabel.text = model.title
        nameLabel.text = model.agentName
        jobTitleLabel.text = model.agentJobTitle

        if let phoneNumber = model.phoneNumber {
            phoneButton.setTitle(phoneNumber, for: .normal)
            phoneButton.isHidden = false
        }

        remoteImageView.dataSource = remoteImageViewDataSource
        remoteImageView.loadImage(for: model.imageUrl, imageWidth: imageSize.width)
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        remoteImageView.layer.cornerRadius = min(remoteImageView.bounds.height, remoteImageView.bounds.width) / 2
    }

    // MARK: - Actions

    @objc private func phoneButtonTapped() {
        delegate?.agentProfileViewDidSelectPhoneButton(self)
    }
}

// MARK: - Private extensions

private extension Label {
    static func create(style: Label.Style) -> Label {
        let label = Label(style: style, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }
}
