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
    private var timer: Timer?
    private var durationPerProgressInSeconds: Double = 5
    private let frameRate: CGFloat = 60
    private var stepSize: Double { 1 / (frameRate * durationPerProgressInSeconds) }

    private var currentProgressView: UIProgressView? {
        progressViews[safe: currentIndex]
    }

    // MARK: - Internal properties

    weak var delegate: ProgressViewDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Internal methods

    func configure(withNumberOfProgresses numberOfProgresses: Int) {
        reset()

        while progressViews.count < numberOfProgresses {
            let progressView = createProgressView()
            progressViews.append(progressView)
            stackView.addArrangedSubview(progressView)
        }
    }

    func startAnimating(durationPerProgressInSeconds: Double) {
        self.durationPerProgressInSeconds = durationPerProgressInSeconds
        startTimer()
    }

    func resumeOngoingAnimationsIfAny() {
        guard let timer = timer, !timer.isValid else { return }
        startTimer()
    }

    func pauseAnimations() {
        timer?.invalidate()
    }

    func reset() {
        timer?.invalidate()
        currentIndex = 0
        progressViews.forEach({ $0.removeFromSuperview() })
        progressViews.removeAll()
    }

    func setActiveIndex(_ index: Int, startAnimations: Bool) {
        guard
            progressViews.indices.contains(index)
        else { return }

        pauseAnimations()
        currentIndex = index

        progressViews.prefix(upTo: index).forEach({ $0.progress = 1 })
        progressViews.suffix(from: index).forEach({ $0.progress = 0 })

        if startAnimations {
            startTimer()
        }
    }

    // MARK: - Private methods

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1/frameRate, target: self, selector: #selector(incrementProgress), userInfo: nil, repeats: true)
    }

    private func finishProgressAndContinueIfNext() {
        timer?.invalidate()

        if currentProgressView == progressViews.last {
            delegate?.progressViewDidFinishProgress(self, isLastProgress: true)
            return
        }

        currentIndex += 1
        delegate?.progressViewDidFinishProgress(self, isLastProgress: false)
        startTimer()
    }

    @objc private func incrementProgress() {
        guard let progressView = currentProgressView else { return }

        let progress = progressView.progress + Float(stepSize)
        progressView.setProgress(progress, animated: true)

        if progressView.progress == 1 {
            finishProgressAndContinueIfNext()
        }
    }

    private func createProgressView() -> UIProgressView {
        let progressView = UIProgressView(withAutoLayout: true)
        progressView.progressTintColor = .milk
        progressView.trackTintColor = .milk.withAlphaComponent(0.5)
        progressView.dropShadow(color: .black, opacity: 0.2, offset: .zero, radius: 5)
        return progressView
    }
}
