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
    private var progressViews = [ProgressBarView]()
    private var timer: Timer?
    private var durationPerProgressInSeconds: Double = 5
    private let frameRate: Double = 60
    private var stepSize: Double { 1 / (frameRate * durationPerProgressInSeconds) }

    private var currentProgressBarView: ProgressBarView? {
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
            let progressView = ProgressBarView()
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

        progressViews.prefix(upTo: index).forEach({ $0.setProgress(1) })
        progressViews.suffix(from: index).forEach({ $0.setProgress(0) })

        if startAnimations {
            startTimer()
        }
    }

    // MARK: - Private methods

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1/frameRate, target: self, selector: #selector(incrementProgress), userInfo: nil, repeats: true)
    }

    @objc private func incrementProgress() {
        guard let progressBarView = currentProgressBarView else { return }

        progressBarView.setProgress(progressBarView.progress + CGFloat(stepSize))

        if progressBarView.progress == 1 {
            finishProgressAndContinueIfNext()
        }
    }

    private func finishProgressAndContinueIfNext() {
        timer?.invalidate()

        if currentProgressBarView == progressViews.last {
            delegate?.progressViewDidFinishProgress(self, isLastProgress: true)
            return
        }

        currentIndex += 1
        delegate?.progressViewDidFinishProgress(self, isLastProgress: false)
        startTimer()
    }
}
