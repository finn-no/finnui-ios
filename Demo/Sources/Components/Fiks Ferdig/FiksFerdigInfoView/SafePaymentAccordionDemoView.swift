import FinniversKit
@testable import FinnUI
import DemoKit

final class FiksFerdigSafePaymentInfoDemoView: UIView {
    var accordionView: FiksFerdigSafePaymentInfoView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(forTweakAt: 0)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(with viewModel: FiksFerdigSafePaymentInfoViewModel) {
        accordionView?.removeFromSuperview()

        let accordionView = FiksFerdigSafePaymentInfoView(
            viewModel: viewModel,
            withAutoLayout: true
        )

        addSubview(accordionView)

        NSLayoutConstraint.activate([
            accordionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            accordionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            accordionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])

        accordionView.layoutIfNeeded()

        self.accordionView = accordionView
    }
}

// MARK: - TweakableDemo

extension FiksFerdigSafePaymentInfoDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case singleLinedText
        case multilinedText
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .singleLinedText:
            let viewModel = FiksFerdigSafePaymentInfoViewModel(
                headerTitle: "Trygg betaling",
                timeLineItems: [
                    TimeLineItem(title: "Betal med Vipps eller kort"),
                    TimeLineItem(title: "Varen leveres hjem til deg"),
                    TimeLineItem(title: "Du har 24 timer til å sjekke varen")
                ]
            )
            setup(with: viewModel)
        case .multilinedText:
            let viewModel = FiksFerdigSafePaymentInfoViewModel(
                headerTitle: "Trygg betaling",
                timeLineItems: [
                    TimeLineItem(title: "Betal med Vipps eller kort Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                    TimeLineItem(title: "Varen leveres hjem til deg"),
                    TimeLineItem(title: "Du har 24 timer til å sjekke varen Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor")
                ]
            )
            setup(with: viewModel)
        }
    }
}

// MARK: - FiksFerdigAccordionViewModelDelegate

extension FiksFerdigSafePaymentInfoDemoView: FiksFerdigAccordionViewModelDelegate {
    func didChangeExpandedState(isExpanded: Bool) {
        print("didChangeExpandedState: \(isExpanded)")
    }
}
