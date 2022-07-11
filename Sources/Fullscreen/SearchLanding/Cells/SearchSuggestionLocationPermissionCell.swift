import UIKit
import FinniversKit

class SearchSuggestionLocationPermissionCell: UITableViewCell {

    // MARK: - Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    public lazy var enableLocationButton: Button = {
        let margins = UIEdgeInsets(top: .spacingXS, left: .spacingM, bottom: .spacingXS, right: .spacingM)
        let style = Button.Style.default.overrideStyle(margins: margins)
        let button = Button(style: style, size: .small, withAutoLayout: true)
        button.setTitle("Skru på", for: .normal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }()

    // MARK: - Init

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        contentView.addSubview(enableLocationButton)
        contentView.addSubview(titleLabel)
        titleLabel.fillInSuperview(insets: UIEdgeInsets(top: .spacingL, leading: .spacingM, bottom: -.spacingL, trailing: -.spacingXXL))

        NSLayoutConstraint.activate([
            enableLocationButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            enableLocationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),
            enableLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Configure

    func configure(with title: String) {
        titleLabel.text = title
    }
}
