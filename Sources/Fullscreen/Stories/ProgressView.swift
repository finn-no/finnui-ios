import Foundation
import UIKit
import FinniversKit

protocol ProgressViewDelegate: AnyObject {
    func progressViewDidFinishProgress(_ progressView: ProgressView, isLastProgress: Bool)
}

class ProgressView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingXS, withAutoLayout: true)
        stackView.distribution = .fillEqually
        return stackView
    }()

    private var currentIndex: Int = 0
    private var progressViews = [UIProgressView]()
    private var currentProgressView: UIProgressView?
    private var timer: Timer?

    weak var delegate: ProgressViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    func configure(withNumberOfProgresses numberOfProgresses: Int) {
        progressViews.forEach({ $0.removeFromSuperview() })
        progressViews.removeAll()
        currentProgressView = nil
        currentIndex = 0

        while progressViews.count < numberOfProgresses {
            let progressView = createProgressView()
            progressViews.append(progressView)
            stackView.addArrangedSubview(progressView)
        }
    }

    func startAnimating() {
        currentIndex = 0
        startNextProgress()
    }

    func setActiveIndex(_ index: Int) {
        guard progressViews.indices.contains(index) else { return }
        currentIndex = index

        progressViews.prefix(upTo: index).forEach({ $0.progress = 1 })
        progressViews.suffix(from: index).forEach({ $0.progress = 0 })

        startNextProgress()
    }

    private func startNextProgress() {
        timer?.invalidate()

        guard let progressView = progressViews[safe: currentIndex] else { return }

        self.currentProgressView = progressView
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }

    private func finishProgressAndContinueIfNext() {
        if currentIndex == progressViews.count - 1 {
            delegate?.progressViewDidFinishProgress(self, isLastProgress: true)
            return
        }
        currentIndex += 1
        delegate?.progressViewDidFinishProgress(self, isLastProgress: false)
        startNextProgress()
    }

    @objc func updateProgressView() {
        guard let progressView = currentProgressView else { return }

        progressView.progress += 0.001
        progressView.setProgress(progressView.progress, animated: true)
        if progressView.progress == 1 {
            timer?.invalidate()
            finishProgressAndContinueIfNext()
        }
    }

    private func createProgressView() -> UIProgressView {
        let progressView = UIProgressView(withAutoLayout: true)
        progressView.progressTintColor = .milk
        progressView.trackTintColor = .sardine.withAlphaComponent(0.5)
        return progressView
    }
}
