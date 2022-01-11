import UIKit
import FinniversKit
import FinnUI

class FadedExpandDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Short view", action: { [weak self] in
            self?.configure(contentView: .shortView)
        }),
        TweakingOption(title: "Tall view", action: { [weak self] in
            self?.configure(contentView: .tallView)
        }),
        TweakingOption(title: "Title view", action: { [weak self] in
            self?.configure(contentView: .titleView, verticalMargin: .spacingM)
        }),
    ]

    // MARK: - Private properties

    private var fadedExpandView: FadedExpandView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func configure(contentView: UIView, verticalMargin: CGFloat = 0) {
        if let oldView = fadedExpandView {
            oldView.removeFromSuperview()
        }

        let view = FadedExpandView(
            contentView: contentView,
            verticalMargin: verticalMargin,
            buttonTitle: "Se hele annonsen",
            delegate: self,
            withAutoLayout: true
        )

        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        fadedExpandView = view
    }
}

// MARK: - FadedExpandViewDelegate

extension FadedExpandDemoView: FadedExpandViewDelegate {
    func fadedExpandViewDidSelectExpandButton(_ view: FadedExpandView) {
        print("👉 Did tap expand button.")
    }
}

// MARK: - Private extensions

private extension UIView {
    static var shortView = create(title: "Short view", backgroundColor: .secondaryBlue, height: 150)
    static var tallView = create(title: "Tall view", backgroundColor: .pea, height: 550)

    static var titleView: UIView {
        let titleView = ObjectPageTitleView(titleStyle: .body, subtitleStyle: .title2, withAutoLayout: true)
        titleView.configure(
            withTitle: "Hareveien 11",
            subtitle: "7 lekre selveierleiligheter uten gjenboere",
            ribbonViewModel: RibbonViewModel(style: .warning, title: "Solgt")
        )
        return titleView
    }

    private static func create(title: String, backgroundColor: UIColor, height: CGFloat) -> UIView {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = backgroundColor

        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textAlignment = .center
        label.text = title

        view.addSubview(label)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: .spacingM),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacingM),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.spacingM)
        ])

        return view
    }
}
