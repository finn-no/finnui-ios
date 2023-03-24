import FinniversKit

extension MotorSidebarView {
    class SectionsContainerView: UIView {

        // MARK: - Private properties

        private lazy var sectionsStackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)

        // MARK: - Init

        init(sections: [ViewModel.Section], sectionDelegate: MotorSidebarSectionViewDelegate) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(sections: sections, sectionDelegate: sectionDelegate)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(sections: [ViewModel.Section], sectionDelegate: MotorSidebarSectionViewDelegate) {
            clipsToBounds = true
            layer.borderWidth = 1
            layer.cornerRadius = 8

            addSubview(sectionsStackView)
            sectionsStackView.fillInSuperview()

            let isOnlySection = sections.count == 1
            sections.enumerated().forEach { index, section in
                if index != 0 {
                    sectionsStackView.addArrangedSubview(.hairlineView())
                }

                let sectionView = SectionView(
                    section: section,
                    isOnlySection: isOnlySection,
                    delegate: sectionDelegate
                )
                sectionsStackView.addArrangedSubview(sectionView)
            }
        }

        // MARK: - Overrides

        override func layoutSubviews() {
            super.layoutSubviews()
            layer.borderColor = .borderDefault
        }
    }
}

private extension UIView {
    static func hairlineView() -> UIView {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .borderDefault
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
}
