//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit


public final class SplashViewTori: UIView {

    public weak var delegate: SplashViewDelegate?

    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .toriSplashLogo)
        return imageView
    }()

    private lazy var logoContainer = UIView(withAutoLayout: true)

    private lazy var footerView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .schibstedFooterTori)
        return imageView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSplash()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSplash()
    }

    // MARK: - Setup

    private func setupSplash() {
        backgroundColor = .nmpBrandColorSecondary

        logoContainer.addSubview(logoView)

        addSubview(logoContainer)
        addSubview(footerView)

        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),

            logoContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logoContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoContainer.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            footerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            footerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.spacingL),
        ])
    }

    public func handleSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.removeSplashView(self)
        }
    }
}
