import UIKit
import FinniversKit

class FrontpageSearchSectionHeader: UICollectionReusableView {

    private lazy var titleLabel = Label(style: .bodyStrong, withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setContentHuggingPriority(.required, for: .horizontal)
        backgroundColor = .bgPrimary
        titleLabel.textColor = .textPrimary
        
    }

    func configure() {
        titleLabel.removeFromSuperview()
      }
    
    func configure(with title: String) {
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.fillInSuperview(insets: UIEdgeInsets(top: .spacingM, leading: .spacingM, bottom: -.spacingM, trailing: -.spacingM))
    }
}
