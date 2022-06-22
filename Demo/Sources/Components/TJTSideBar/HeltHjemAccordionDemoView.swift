import FinniversKit
@testable import FinnUI

final class HeltHjemAccordionDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Single lined text") { [unowned self] in
            let viewModel = HeltHjemAccordionViewModel(
                headerTitle: "Varen sendes med",
                providerName: "Helthjem",
                message: "Du betaler 60 kr for frakten",
                isExpanded: true
            )
            setup(with: viewModel)
        },
        TweakingOption(title: "Multilined text") { [unowned self] in
             let viewModel = HeltHjemAccordionViewModel(
                headerTitle: "Varen sendes med",
                providerName: "Helthjem idjaisj daj id aisdijasid as asduhsahdahsd daijsidj asja",
                message: "Du betaler 60 kr for frakten sdiasiu djiajs idj asij diasj idj asij dias",
                isExpanded: true
            )
            setup(with: viewModel)
        }
    ]

    var viewModel: HeltHjemAccordionViewModel?
    var accordionView: HeltHjemAccordionView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action!()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(with viewModel: HeltHjemAccordionViewModel) {
        accordionView?.removeFromSuperview()

        let accordionView = HeltHjemAccordionView(
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

        self.viewModel = viewModel
        self.accordionView = accordionView
        viewModel.delegate = self
    }
}

extension HeltHjemAccordionDemoView: HeltHjemAccordionViewModelDelegate {
    func didChangeExpandedState(isExpanded: Bool) {
        print("didChangeExpandedState: \(isExpanded)")
    }
}
