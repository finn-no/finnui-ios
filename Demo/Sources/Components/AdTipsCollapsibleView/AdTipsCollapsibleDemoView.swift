import FinnUI
import FinniversKit
import UIKit
import DemoKit

class AdTipsCollapsibleDemoView: UIView, Demoable {

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

    private lazy var manualExpandButton: Button = {
        let button = Button(style: .callToAction, size: .small, withAutoLayout: true)
        button.setTitle("Expand or collapse view", for: .normal)
        button.addTarget(self, action: #selector(toggleExpandOrCollapse), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configureCollapsibleContentView(title: "Spesifikasjoner")
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(stackView)
        stackView.fillInSuperview()

        addSubview(manualExpandButton)
        addSubview(scrollView)
        scrollView.alwaysBounceVertical = true

        NSLayoutConstraint.activate([
            manualExpandButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            manualExpandButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            manualExpandButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            scrollView.topAnchor.constraint(equalTo: manualExpandButton.bottomAnchor, constant: .spacingS),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Private methods

    private func configureCollapsibleContentView(
        title: String,
        contentView: UIView? = nil
    ) {
        collapsibleContentView?.removeFromSuperview()

        let collapsibleContentView = AdTipsCollapsibleView(identifier: "adtips-demo-view", delegate: self, withAutoLayout: true)
        collapsibleContentView.configure(with: title, expandCollapseButtonTitles: (expanded: "Vis mindre", collapsed: "Vis mer"), headerImage: UIImage(named: .buyingTipsCat), contentView: contentView ?? self.contentView)

        scrollView.addSubview(collapsibleContentView)
        collapsibleContentView.fillInSuperview(margin: .spacingM)
        collapsibleContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL).isActive = true

        self.collapsibleContentView = collapsibleContentView
    }

    // MARK: - Actions

    @objc private func toggleExpandOrCollapse() {
        guard let collapsibleContentView = collapsibleContentView else { return }
        collapsibleContentView.configure(isExpanded: !collapsibleContentView.isExpanded, withAnimation: false)
    }
}

// MARK: - AdTipsCollapsibleViewDelegate

extension AdTipsCollapsibleDemoView: AdTipsCollapsibleViewDelegate {
    func adTipsCollapsibleView(_ view: AdTipsCollapsibleView, withIdentifier identifier: String, didChangeExpandState isExpanded: Bool) {
        print("❕ View with identifier '\(identifier)' changed expanded state. Is expanded: \(isExpanded ? "✅" : "❌")")
    }
}
