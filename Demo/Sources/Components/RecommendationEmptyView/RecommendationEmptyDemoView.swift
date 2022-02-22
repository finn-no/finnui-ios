//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit
import UIKit

final class RecommendationEmptyDemoView: UIView {
    private lazy var viewModel = RecommendationEmptyViewModel(
        titleText: "Oisann",
        detailText: "Vi har desverre ikke noen anbefalinger tilgjengelig for deg"
    )

    private lazy var recommendationEmptyView: RecommendationEmptyView = {
        let view = RecommendationEmptyView(withAutoLayout: true)
        view.configure(viewModel)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(recommendationEmptyView)
        recommendationEmptyView.fillInSuperview(margin: .spacingM)
    }
}
