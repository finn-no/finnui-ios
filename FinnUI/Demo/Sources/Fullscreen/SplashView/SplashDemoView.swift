//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import UIKit
import DemoKit

class SplashDemoView: UIView, Demoable {
    private lazy var view = SplashView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.view.animate()
        })
    }
}
