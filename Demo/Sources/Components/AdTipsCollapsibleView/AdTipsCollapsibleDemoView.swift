import FinnUI
import FinniversKit
import UIKit

class AdTipsCollapsibleDemoView: UIView, Tweakable {

    // MARK: - Private properties

    private var collapsibleContentView: AdTipsCollapsibleView?
    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = .spacingM
        (1...9).forEach({ index in
            let label = Label(style: .body, withAutoLayout: true)
            label.text = "Item \(index)"
            stackView.addArrangedSubview(label)
        })
        return stackView
    }()

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Plain style", action: { [weak self] in
            self?.configureCollapsibleContentView(title: "Spesifikasjoner")
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
        contentView.addSubview(stackView)
        stackView.fillInSuperview()

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.alwaysBounceVertical = true
    }

    private func configureCollapsibleContentView(
        title: String,
        contentView: UIView? = nil
    ) {
        collapsibleContentView?.removeFromSuperview()

        let collapsibleContentView = AdTipsCollapsibleView(withAutoLayout: true)
        collapsibleContentView.configure(with: title, expandCollapseButtonTitles: (expanded: "Vis mindre", collapsed: "Vis mer"), headerImage: UIImage(named: "virtualViewing"), contentView: contentView ?? self.contentView)

        scrollView.addSubview(collapsibleContentView)
        collapsibleContentView.fillInSuperview(margin: .spacingM)
        collapsibleContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL).isActive = true

        self.collapsibleContentView = collapsibleContentView
    }
}
