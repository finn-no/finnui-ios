import UIKit
import FinniversKit
import FinnUI

class FadedExpandableDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Short view", action: { [weak self] in
            self?.configure(contentView: .shortView, buttonVerticalMargin: .spacingM)
        }),
        TweakingOption(title: "Tall view", action: { [weak self] in
            self?.configure(contentView: .tallView, buttonVerticalMargin: .spacingM)
        }),
        TweakingOption(title: "Title view", action: { [weak self] in
            self?.configure(contentView: .titleView, contentViewVerticalMargin: .spacingM, buttonVerticalMargin: .spacingM)
        }),
    ]

    // MARK: - Private properties

    private var fadedExpandableView: FadedExpandableView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func configure(contentView: UIView, contentViewVerticalMargin: CGFloat = 0, buttonVerticalMargin: CGFloat = 0) {
        if let oldView = fadedExpandableView {
            oldView.removeFromSuperview()
        }

        let view = FadedExpandableView(
            contentView: contentView,
            contentViewVerticalMargin: contentViewVerticalMargin,
            buttonVerticalMargin: buttonVerticalMargin,
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

        fadedExpandableView = view
    }
}

// MARK: - FadedExpandViewDelegate

extension FadedExpandableDemoView: FadedExpandableViewDelegate {
    func fadedExpandableViewDidSelectExpandButton(_ view: FadedExpandableView) {
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