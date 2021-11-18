import Foundation
import UIKit

class ProgressBarView: UIView {
    private lazy var backgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .milk
        view.alpha = 0.5
        view.layer.cornerRadius = 1.5
        return view
    }()

    private lazy var progressView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .milk
        view.layer.cornerRadius = 1.5
        return view
    }()

    private lazy var progressWidthConstraint: NSLayoutConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
    private(set) var progress: CGFloat

    // MARK: - Init

    override init(frame: CGRect) {
        self.progress = 0
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(progressView)
        addSubview(backgroundView)
        backgroundView.fillInSuperview()

        dropShadow(color: .black, opacity: 0.2, offset: .zero, radius: 5)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 3),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressWidthConstraint
        ])
    }

    // MARK: - Internal methods

    func setProgress(_ progress: CGFloat) {
        guard self.progress != progress else { return }
        self.progress = min(progress, 1)
        progressWidthConstraint.constant = frame.width * self.progress
    }
}
