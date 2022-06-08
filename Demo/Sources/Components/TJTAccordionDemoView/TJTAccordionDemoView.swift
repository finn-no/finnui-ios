import FinniversKit
import FinnUI

final class TJTAccordionDemoView: UIView {
    let accordionView = TJTAccordionView(withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(accordionView)

        NSLayoutConstraint.activate([
            accordionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            accordionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            accordionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])
    }
}
