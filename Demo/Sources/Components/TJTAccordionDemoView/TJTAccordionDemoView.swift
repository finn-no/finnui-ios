import FinniversKit
import FinnUI

final class TJTAccordionDemoView: UIView {
    var viewModel: TJTAccordionViewModel
    let accordionView: TJTAccordionView

    override init(frame: CGRect) {
        self.viewModel = TJTAccordionViewModel(
            title: "Fiks ferdig",
            icon: UIImage(systemName: "shippingbox")!,
            isExpanded: true
        )
        self.accordionView = TJTAccordionView(
            viewModel: viewModel,
            withAutolayout: true
        )
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

        let label = Label(style: .body)
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        accordionView.addViewToContentView(label)
    }
}
