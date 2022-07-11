//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit
import UIKit

final class RecommendationConsentDemoView: UIView {
    private lazy var viewModel = RecommendationConsentViewModel(
        titleText: "Du må tillate personlig tilpasset FINN",
        detailText: "For å vise deg relevante FINN-annonser må vi lagre søkehistorikken din hos oss. Dataene blir ikke delt med andre. Du kan endre innstillingene senere på Min FINN.",
        buttonText: "Tillat og vis anbefalinger"
    )

    private lazy var recommendationConsentView: RecommendationConsentView = {
        let view = RecommendationConsentView(withAutoLayout: true)
        view.configure(viewModel)
        view.delegate = self
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
        addSubview(recommendationConsentView)
        recommendationConsentView.fillInSuperview(margin: .spacingM)
    }
}

// MARK: - RecommendationConsentViewDelegate

extension RecommendationConsentDemoView: RecommendationConsentViewDelegate {
    func recommendationConsentViewDidTapAllowButton(_ view: RecommendationConsentView) {
        print("Tap allow button")
    }
}
