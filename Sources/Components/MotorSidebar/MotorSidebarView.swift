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
        let mainSection = SectionsContainerView(
            sections: viewModel.mainSections,
            shouldChangeLayoutWhenCompact: true,
            sectionDelegate: self
        )
        stackView.addArrangedSubview(mainSection)

        if let secondarySectionModel = viewModel.secondary {
            let secondarySection = SectionsContainerView(
                sections: [secondarySectionModel],
                shouldChangeLayoutWhenCompact: false,
                sectionDelegate: self
            )
            stackView.addArrangedSubview(secondarySection)
        }

        addSubview(stackView)
        stackView.fillInSuperview()
        configurePresentation()
    }

    // MARK: - Overrides

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            configurePresentation()
        }
    }

    // MARK: - Private methods

    private func configurePresentation() {
        switch traitCollection.horizontalSizeClass {
        case .regular:
            stackView.spacing = .spacingM
        default:
            stackView.spacing = 0
        }
    }
}

// MARK: - MotorSidebarSectionViewDelegate

extension MotorSidebarView: MotorSidebarSectionViewDelegate {
    func motorSidebarSectionView(_ sectionView: SectionView, didSelectButton viewModel: ViewModel.Button) {
        delegate?.motorSidebarView(self, didSelectButtonWithIdentifier: viewModel.identifier, urlString: viewModel.urlString)
    }
}
