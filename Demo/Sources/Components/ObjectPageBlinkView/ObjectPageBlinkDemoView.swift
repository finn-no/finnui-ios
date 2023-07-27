import FinniversKit
import FinnUI
import DemoKit

class ObjectPageBlinkDemoView: UIView {

    private lazy var blinkView: ObjectPageBlinkView = {
        let view = ObjectPageBlinkView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        configure(forTweakAt: 0)

        addSubview(blinkView)
        NSLayoutConstraint.activate([
            blinkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            blinkView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            blinkView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - TweakableDemo

extension ObjectPageBlinkDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case `default`
        case withoutIncreasedClickPercentage
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .default:
            blinkView.configure(with: .default)
        case .withoutIncreasedClickPercentage:
            blinkView.configure(with: .withoutIncreasedClickPercentage)
        }
    }
}

// MARK: - ObjectPageBlinkViewDelegate

extension ObjectPageBlinkDemoView: ObjectPageBlinkViewDelegate {
    func objectPageBlinkViewDidSelectReadMoreButton(view: ObjectPageBlinkView) {
        print("🔥🔥🔥🔥 \(#function)")
    }
}

extension ObjectPageBlinkViewModel {
    static var `default`: ObjectPageBlinkViewModel = {
        ObjectPageBlinkViewModel(
            title: "Denne annonsen har fått ekstra effekt fra BLINK",
            increasedClickPercentage: 73,
            increasedClickDescription: "flere klikk enn vanlig",
            readMoreButtonTitle: "Få flere klikk på din boligannonse"
        )
    }()

    static var withoutIncreasedClickPercentage: ObjectPageBlinkViewModel = {
        ObjectPageBlinkViewModel(
            title: "Denne annonsen har fått ekstra effekt fra BLINK",
            increasedClickPercentage: nil,
            increasedClickDescription: "flere klikk enn vanlig",
            readMoreButtonTitle: "Få flere klikk på din boligannonse"
        )
    }()
}
