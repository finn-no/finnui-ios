import FinnUI
import UIKit

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

public class HelthjemDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption]  = [
        TweakingOption(title: "Ads without opt in", action: { [weak self] in
            self?.helthjemView.configure(HelthjemViewModel.AdsWithoutOptIn)
        }),
        TweakingOption(title: "Ads with opt in", action: { [weak self] in
            self?.helthjemView.configure(HelthjemViewModel.AdsWithOptIn)
        }),
    ]

    private lazy var helthjemView: HelthjemView = {
        let view = HelthjemView()
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

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

extension HelthjemDemoView: HelthjemViewDelegate {
    public func helthjemViewDidSelectPrimaryButton(_ view: HelthjemView) {
        print("Did tap primary button")
    }

    public func helthjemViewDidSelectSecondaryButton(_ view: HelthjemView) {
        print("Did tap secondary button")
    }
}

private extension NumberFormatter {
    static var spokenFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }()
}
