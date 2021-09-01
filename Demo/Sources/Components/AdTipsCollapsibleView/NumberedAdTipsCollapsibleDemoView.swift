@testable import FinnUI
import FinniversKit
import UIKit

class NumberedAdTipsCollapsibleDemoView: UIView, Tweakable {
    // MARK: - Private properties

    private lazy var demoView = NumberedAdTipsCollapsibleView(identifier: "cat-dog-tips", delegate: self, withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Cat buying tips", action: { [weak self] in
            self?.configure(for: .cat)
        }),
        TweakingOption(title: "Dog buying tips", action: { [weak self] in
            self?.configure(for: .dog)
        }),
        TweakingOption(title: "\"Unknown\" tips – aka. without image", action: { [weak self] in
            self?.configure(for: .unknown)
        }),
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.alwaysBounceVertical = true

        scrollView.addSubview(demoView)
        demoView.fillInSuperview(margin: .spacingM)
        demoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL).isActive = true
    }

    // MARK: - Private methods

    private func configure(for kind: Kind) {
        demoView.configure(
            with: kind.title,
            expandCollapseButtonTitles: (expanded: "Vis mindre", collapsed: "Vis mer"),
            headerImage: kind.image,
            items: BuyingTips.demoItems
        )
    }
}

// MARK: - CatDogBuyingTipsViewDelegate

extension NumberedAdTipsCollapsibleDemoView: NumberedAdTipsCollapsibleViewDelegate {
    func numberedAdTipsCollapsibleView(_ view: NumberedAdTipsCollapsibleView, withIdentifier identifier: String, didSelectActionButtonForItem selectedItem: NumberedListItem) {
        print("👉 View with identifier '\(identifier)' selected button with title: '\(selectedItem.actionButtonTitle ?? "")'")
    }

    public func adTipsCollapsibleView(_ view: AdTipsCollapsibleView, withIdentifier identifier: String, didChangeExpandState isExpanded: Bool) {
        print("❕ View with identifier '\(identifier)' changed expanded state. Is expanded: \(isExpanded ? "✅" : "❌")")
    }
}

// MARK: - Private types / extensions

private enum Kind {
    case cat
    case dog
    case unknown

    var title: String {
        switch self {
        case .cat:
            return "6 tips når du skal kjøpe katt"
        case .dog:
            return "6 tips når du skal kjøpe hund"
        case .unknown:
            return "Masse tips til deg som skal kjøpe noe"
        }
    }

    var image: UIImage? {
        switch self {
        case .cat:
            return UIImage(named: .buyingTipsCat)
        case .dog:
            return UIImage(named: .buyingTipsDog)
        case .unknown:
            return nil
        }
    }
}

private struct BuyingTips: NumberedListItem {
    let heading: String?
    let body: String
    let actionButtonTitle: String?

    init(heading: String?, body: String, actionButtonTitle: String? = nil) {
        self.heading = heading
        self.body = body
        self.actionButtonTitle = actionButtonTitle
    }

    static var demoItems: [BuyingTips] = [
        BuyingTips(
            heading: "Valget om å skaffe seg hund må være godt gjennomtenkt",
            body: "Husk at hunder lever i mange år, må passes på av noen i feriene og kommer med en del utgifter til f.eks fôr og veterinær."
        ),
        BuyingTips(
            heading: "Velg en hunderase som passer for deg og din hverdag",
            body: "Norsk Kennel Klub kan gi deg nyttige tips til valg av rase.",
            actionButtonTitle: "Sjekk tipsene"
        ),
        BuyingTips(
            heading: "Kjøp hunden av en seriøs oppdretter",
            body: "Kontakt raseklubben for å få en liste over godkjente oppdrettere. En seriøs oppdretter lar deg besøke valpen og se den sammen med mor og resten av valpekullet. Hos Mattilsynet kan du lese mer om forhåndsregler du bør ta for å ikke kjøpe en ulovlig importert hund.",
            actionButtonTitle: "Forhåndsregler"
        )
    ]
}
