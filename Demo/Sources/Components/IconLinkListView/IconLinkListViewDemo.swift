import FinnUI
import FinniversKit
import DemoKit

class IconLinkListViewDemo: UIView {

    // MARK: - Private properties

    private lazy var iconLinkListView = IconLinkListView(delegate: self, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(iconLinkListView)
        configure(forTweakAt: 0)

        NSLayoutConstraint.activate([
            iconLinkListView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconLinkListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            iconLinkListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

// MARK: - TweakableDemo

extension IconLinkListViewDemo: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case twoItems
        case threeItems
        case singleItem
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .twoItems:
            iconLinkListView.configure(with: [.videoLink, .virtualViewing])
        case .threeItems:
            iconLinkListView.configure(with: [.videoLink, .virtualViewing, .virtualViewing])
        case .singleItem:
            iconLinkListView.configure(with: [.carPresentation])
        }
    }
}

// MARK: - IconLinkViewDelegate

extension IconLinkListViewDemo: IconLinkViewDelegate {
    func iconLinkViewWasSelected(_ view: IconLinkView, url: String, identifier: String?) {
        print("🔥🔥🔥🔥 IconLinkView tapped with url: \(url), identifier: \(identifier ?? "")")
    }
}

// MARK: - Private extensions

private extension IconLinkViewModel {
    static var videoLink = IconLinkViewModel(
        icon: UIImage(named: .playVideo),
        title: "Videovisning",
        url: "https://www.finn.no",
        identifier: "video"
    )

    static var virtualViewing = IconLinkViewModel(
        icon: UIImage(named: .virtualViewing),
        title: "360° visning",
        url: "https://www.finn.no",
        identifier: "virtual-viewing"
    )

    static var carPresentation = IconLinkViewModel(
        icon: UIImage(named: .playVideo),
        title: "Se videopresentasjon av bilen",
        url: "https://www.finn.no",
        identifier: "video"
    )
}
