import UIKit
import FinniversKit

class SearchSuggestionsSectionHeader: UITableViewHeaderFooterView {

    private lazy var titleLabel = Label(style: .bodyStrong, withAutoLayout: true)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setContentHuggingPriority(.required, for: .horizontal)
        contentView.backgroundColor = .bgPrimary
        titleLabel.textColor = .textPrimary
        addSubview(titleLabel)
        titleLabel.fillInSuperview(insets: UIEdgeInsets(top: .spacingXS, leading: .spacingM, bottom: -.spacingXS, trailing: -.spacingM))
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}
