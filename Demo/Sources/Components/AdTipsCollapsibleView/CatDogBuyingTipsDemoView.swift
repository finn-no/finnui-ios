import FinnUI
import FinniversKit
import UIKit

class CatDogBuyingTipsDemoView: UIView, Tweakable {
    // MARK: - Private properties

    private lazy var demoView = CatDogBuyingTipsView(withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Cat buying tips", action: { [weak self] in
            self?.configure(for: .cat)
        }),
        TweakingOption(title: "Dog buying tips", action: { [weak self] in
            self?.configure(for: .dog)
        })
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

    private func configure(for kind: CatDogBuyingTipsView.Kind) {
        demoView.configure(
            kind: kind,
            title: kind.title,
            expandCollapseButtonTitles: (expanded: "Vis mindre", collapsed: "Vis mer"),
            items: CatDogTips.demoItems
        )
    }
}

// MARK: - CatDogBuyingTipsViewDelegate

extension CatDogBuyingTipsDemoView: CatDogBuyingTipsViewDelegate {
    func catDogBuyingTipsView(_ view: CatDogBuyingTipsView, didSelectActioButtonForItem selectedItem: NumberedListItem) {
        print("✅ Selected button with title: \"\(selectedItem.actionButtonTitle ?? "")\"")
    }
}

// MARK: - Private types / extensions

private extension CatDogBuyingTipsView.Kind {
    var title: String {
        switch self {
        case .cat:
            return "6 tips når du skal kjøpe katt"
        case .dog:
            return "6 tips når du skal kjøpe hund"
        }
    }
}

private struct CatDogTips: NumberedListItem {
    let title: String?
    let body: String
    let actionButtonTitle: String?

    init(title: String?, body: String, actionButtonTitle: String? = nil) {
        self.title = title
        self.body = body
        self.actionButtonTitle = actionButtonTitle
    }

    static var demoItems: [CatDogTips] = [
        CatDogTips(
            title: "Valget om å skaffe seg hund må være godt gjennomtenkt",
            body: "Husk at hunder lever i mange år, må passes på av noen i feriene og kommer med en del utgifter til f.eks fôr og veterinær."
        ),
        CatDogTips(
            title: "Velg en hunderase som passer for deg og din hverdag",
            body: "Norsk Kennel Klub kan gi deg nyttige tips til valg av rase.",
            actionButtonTitle: "Sjekk tipsene"
        ),
        CatDogTips(
            title: "Kjøp hunden av en seriøs oppdretter",
            body: "Kontakt raseklubben for å få en liste over godkjente oppdrettere. En seriøs oppdretter lar deg besøke valpen og se den sammen med mor og resten av valpekullet. Hos Mattilsynet kan du lese mer om forhåndsregler du bør ta for å ikke kjøpe en ulovlig importert hund.",
            actionButtonTitle: "Forhåndsregler"
        ),
        CatDogTips(
            title: "Sørg for at papirene er i orden",
            body: "Valpen skal ha en nydatert helseattest/valpeattest og den skal være grunnvaksinert. Hvis hunden er ID-merket, skal du få med bekreftelse på det når du kjøper den. Ikke godta å få dokumentasjon ettersendt!"
        ),
        CatDogTips(
            title: "Skriv en skikkelig kjøpekontrakt",
            body: "Her må telefonnummer, navn og adresse på oppdretteren komme tydelig frem. Her finner du Forbrukerrådets kontrakt for kjøp av husdyr.",
            actionButtonTitle: "Se kontrakt"
        ),
        CatDogTips(
            title: "Det er lurt å forsikre hunden",
            body: "Det finnes både veterinærforsikringer og livsforsikringer. Sjekk hos ditt foretrukne forsikringsselskap."
        )
    ]
}
