import UIKit
import FinniversKit

public protocol MotorSidebarViewDelegate: AnyObject {
    func motorSidebarView(_ view: MotorSidebarView, didSelectButtonWithIdentifier identifier: String?, urlString: String?)
    func motorSidebarView(_ view: MotorSidebarView, didToggleExpandOnSectionAt sectionIndex: Int, isExpanded: Bool)
}

public class MotorSidebarView: UIView {

    // MARK: - Public properties

    public weak var delegate: MotorSidebarViewDelegate?

    // MARK: - Private properties

    private let viewModel: ViewModel
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    // MARK: - Init

    public init(
        viewModel: ViewModel,
        delegate: MotorSidebarViewDelegate,
        withAutoLayout: Bool = false
    ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubview(SectionsContainerView(sections: viewModel.mainSections))

        if let secondarySection = viewModel.secondary {
            stackView.addArrangedSubview(SectionsContainerView(sections: [secondarySection]))
        }

        addSubview(stackView)
        stackView.fillInSuperview()
    }
}
