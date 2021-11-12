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

    var currentProgressView: UIProgressView? {
        progressViews[safe: currentIndex]
    }

    private var timer: Timer?
    private var durationPerSlideInSeconds: Double = 5
    private let frameRate: CGFloat = 60
    private var stepSize: Double { 1 / (frameRate * durationPerSlideInSeconds) }

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

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Internal methods

    func configure(withNumberOfProgresses numberOfProgresses: Int) {
        progressViews.forEach({ $0.removeFromSuperview() })
        progressViews.removeAll()
        currentIndex = 0

        while progressViews.count < numberOfProgresses {
            let progressView = createProgressView()
            progressViews.append(progressView)
            stackView.addArrangedSubview(progressView)
        }
    }

    func startAnimating(durationPerSlideInSeconds: Double) {
        self.durationPerSlideInSeconds = durationPerSlideInSeconds
        resumeAnimations()
    }

    func pauseAnimations() {
        timer?.invalidate()
    }

    func resumeAnimations() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1/frameRate, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }

    func setActiveIndex(_ index: Int, resumeAnimations: Bool) {
        guard
            progressViews.indices.contains(index)
        else { return }

        pauseAnimations()

        currentIndex = index

        progressViews.prefix(upTo: index).forEach({ $0.progress = 1 })
        progressViews.suffix(from: index).forEach({ $0.progress = 0 })

        if resumeAnimations {
            self.resumeAnimations()
        }
    }

    // MARK: - Private methods

    private func finishProgressAndContinueIfNext() {
        if currentIndex == progressViews.count - 1 {
            delegate?.progressViewDidFinishProgress(self, isLastProgress: true)
            return
        }
        currentIndex += 1
        delegate?.progressViewDidFinishProgress(self, isLastProgress: false)
        resumeAnimations()
    }

    @objc private func updateProgressView() {
        guard let progressView = currentProgressView else { return }

        progressView.progress += Float(stepSize)
        progressView.setProgress(progressView.progress, animated: true)
        if progressView.progress == 1 {
            timer?.invalidate()
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
