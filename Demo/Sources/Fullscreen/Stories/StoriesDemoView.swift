import Foundation
import UIKit
import FinnUI

class StoriesDemoView: UIView {
    private lazy var storiesView: StoriesView = {
        let view = StoriesView(withAutoLayout: true)
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(storiesView)
        storiesView.fillInSuperview()
    }
}
