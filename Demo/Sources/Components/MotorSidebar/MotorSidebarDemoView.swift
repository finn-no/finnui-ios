import FinnUI
import FinniversKit
import DemoKit

class MotorSidebarDemoView: UIView {

    // MARK: - Private properties

    private var motorSidebar: MotorSidebarView?
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        scrollView.alwaysBounceVertical = true

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
    }

    // MARK: - Private methods

    private func setupSidebar(with viewModel: MotorSidebarView.ViewModel) {
        if let oldView = motorSidebar {
            oldView.removeFromSuperview()
            motorSidebar = nil
        }

        let view = MotorSidebarView(viewModel: viewModel, delegate: self, withAutoLayout: true)

        scrollView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: .spacingM),
            view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: .spacingM),
            view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -.spacingM),
            view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -.spacingM)
        ])

        motorSidebar = view
    }
}

// MARK: - TweakableDemo

extension MotorSidebarDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case `default`
        case withSecondarySection
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .default:
            setupSidebar(with: .demoModel)
        case .withSecondarySection:
            setupSidebar(with: .withSecondarySection)
        }
    }
}

// MARK: - MotorSidebarDelegate

extension MotorSidebarDemoView: MotorSidebarViewDelegate {
    func motorSidebarView(_ view: MotorSidebarView, didSelectButtonWithIdentifier identifier: String?, urlString: String?) {
        print("👉 Did tap button with identifier: '\(identifier ?? "[nil]")' and url: '\(urlString ?? "[nil]")'")
    }

    func motorSidebarView(_ view: MotorSidebarView, didToggleExpandOnSectionAt sectionIndex: Int, isExpanded: Bool) {
        print("👉 Did toggle expand on section at index: '\(sectionIndex)' to '\(isExpanded)'")
    }
}

extension MotorSidebarView.ViewModel {
    static var demoModel: MotorSidebarView.ViewModel {
        MotorSidebarView.ViewModel(
            mainSections: [
                .init(
                    isExpandable: false,
                    ribbon: .init(title: "Smidig handel", backgroundColor: .aqua50),
                    price: .init(title: "Totalpris", value: "491 000 kr"),
                    content: [
                        .init(
                            text: "Avgiftsfri betaling med ",
                            accessibilityLabel: "Avgiftsfri betaling med Blink",
                            inlineImage: .init(
                                image: UIImage(named: .blinkRocketMini),
                                baselineOffset: 0
                            )
                        )
                    ],
                    buttons: [
                        .init(
                            kind: .primary,
                            identifier: "send_message",
                            text: "Send melding",
                            urlString: nil,
                            isExternal: false
                        ),
                        .init(
                            kind: .secondary,
                            identifier: "use_smidig_handel",
                            text: "Bruk Smidig handel",
                            urlString: "https://finn.no",
                            isExternal: true
                        )
                    ]
                ),
                .init(
                    isExpandable: true,
                    isExpanded: false,
                    ribbon: nil,
                    price: nil,
                    header: .init(title: "Smidig handel", icon: UIImage(named: .blinkRocketMini)),
                    content: [
                        .init(text: "Finn hjelper deg gjennom kjøpet:")
                    ],
                    bulletPoints: [
                        "Ferdig utfylt kontrakt med BankID signering",
                        "Betal inntil 500 000 kr med Vipps - helt uten gebyrer",
                        "Rask og enkel registrering av eierskifte"
                    ],
                    buttons: [
                        .init(
                            kind: .link,
                            identifier: "read_more",
                            text: "Les mer om Smidig bilhandel",
                            urlString: "https://finn.no",
                            isExternal: true
                        )
                    ]
                ),
                .init(
                    isExpandable: true,
                    isExpanded: false,
                    ribbon: nil,
                    price: nil,
                    header: .init(title: "BankId-bekreftet eier", icon: UIImage(named: .blinkRocketMini)),
                    content: [
                        .init(text: "Kjøretøyets eier er BankID-bekreftet og stemmer med eieropplysninger hos Statens vegvesen.")
                    ],
                    bulletPoints: [],
                    buttons: []
                )
            ],
            secondary: nil
        )
    }

    static var withSecondarySection: MotorSidebarView.ViewModel {
        MotorSidebarView.ViewModel(
            mainSections: [
                .init(
                    isExpandable: false,
                    price: .init(
                        title: "Totalpris",
                        value: "1 400 000 kr"
                    ),
                    content: [],
                    buttons: [
                        .init(
                            kind: .primary,
                            identifier: "send_message",
                            text: "Send melding",
                            urlString: nil,
                            isExternal: false
                        )
                    ]
                )
            ],
            secondary: .init(
                isExpandable: false,
                header: .init(title: "Smidig handel", icon: UIImage(named: .blinkRocketMini)),
                content: [
                    .init(text: "Vi hjelper deg gjennom alle stegene i kjøpet. Enkelt, trygt og effektivt.")
                ],
                buttons: [
                    .init(
                        kind: .secondary,
                        identifier: "read_more",
                        text: "Slik fungerer Smidig handel",
                        urlString: "https://finn.no",
                        isExternal: true
                    )
                ]
            )
        )
    }
}
