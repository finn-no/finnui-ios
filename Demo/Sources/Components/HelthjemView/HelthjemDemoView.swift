import FinnUI
import UIKit
import DemoKit

extension HelthjemViewModel {
    static var AdsWithoutOptIn: HelthjemViewModel = .init(
        title: "Prøv Helthjem fra 80 kr",
        detail: "Vi hjelper selger å sende varen til deg",
        primaryButtonTitle: "Mer om Helthjem",
        primaryButtonAccessibilityLabel: "Trykk for å lese mer om Helthjem",
        secondaryButtonTitle: "Se alle fraktalternativer",
        secondaryButtonAccessibilityLabel: "Trykk for å lese mer om alle fraktalternativer",
        accessibilityLabel: "Få varen levert på døren av Helthjem for kun \(NumberFormatter.spokenFormatter.string(from: 80) ?? String(80)) kroner"
    )

    static var AdsWithOptIn: HelthjemViewModel = .init(
        title: "Prøv Helthjem fra 80 kr",
        detail: "Vi hjelper selger å sende varen til deg",
        primaryButtonTitle: "Mer om Helthjem",
        primaryButtonAccessibilityLabel: "Trykk for å lese mer om Helthjem",
        accessibilityLabel: "Få varen levert på døren av Helthjem for kun \(NumberFormatter.spokenFormatter.string(from: 80) ?? String(80)) kroner"
    )
}

class HelthjemDemoView: UIView {
    private lazy var helthjemView: HelthjemView = {
        let view = HelthjemView()
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(helthjemView)

        NSLayoutConstraint.activate([
            helthjemView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            helthjemView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])

        helthjemView.configure(HelthjemViewModel.AdsWithoutOptIn)
    }
}
// MARK: - TweakableDemo

extension HelthjemDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case adsWithoutOptIn
        case adsWithOptIn
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .adsWithoutOptIn:
            helthjemView.configure(HelthjemViewModel.AdsWithoutOptIn)
        case .adsWithOptIn:
            helthjemView.configure(HelthjemViewModel.AdsWithOptIn)
        }
    }
}

// MARK: - HelthjemViewDelegate

extension HelthjemDemoView: HelthjemViewDelegate {
    func helthjemViewDidSelectPrimaryButton(_ view: HelthjemView) {
        print("Did tap primary button")
    }

    func helthjemViewDidSelectSecondaryButton(_ view: HelthjemView) {
        print("Did tap secondary button")
    }
}

// MARK: - Private extensions

private extension NumberFormatter {
    static var spokenFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }()
}
