import UIKit
import FinniversKit

class FrontpageSearchSectionFooter: UICollectionReusableView {

    private var footer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setContentHuggingPriority(.required, for: .horizontal)
        addSubview(footer)
        footer.backgroundColor = .bgTertiary
        footer.fillInSuperview()
    }
}
