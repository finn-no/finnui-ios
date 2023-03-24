import UIKit
import FinniversKit

public protocol MotorSidebarViewDelegate: AnyObject {
    func motorSidebarView(_ view: MotorSidebarView, didSelectButtonWithIdentifier identifier: String?, urlString: String?)
    func motorSidebarView(_ view: MotorSidebarView, didToggleExpandOnSectionAt sectionIndex: Int, isExpanded: Bool)
}

public class MotorSidebarView: UIView {

    // MARK: - Private properties

    private let viewModel: ViewModel
    private weak var delegate: MotorSidebarViewDelegate?
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    // MARK: - Init

    public init(
        viewModel: ViewModel,
        delegate: MotorSidebarViewDelegate,
        withAutoLayout: Bool = false
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubview(SectionsContainerView(sections: viewModel.mainSections, sectionDelegate: self))

        if let secondarySection = viewModel.secondary {
            stackView.addArrangedSubview(SectionsContainerView(sections: [secondarySection], sectionDelegate: self))
        }

        addSubview(stackView)
        stackView.fillInSuperview()
    }
}

// MARK: - MotorSidebarSectionViewDelegate

extension MotorSidebarView: MotorSidebarSectionViewDelegate {
    func motorSidebarSectionView(_ sectionView: SectionView, didSelectButton viewModel: ViewModel.Button) {
        delegate?.motorSidebarView(self, didSelectButtonWithIdentifier: viewModel.identifier, urlString: viewModel.urlString)
    }
}
