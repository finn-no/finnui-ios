import FinniversKit

extension MotorSidebarView {
    class SectionsContainerView: UIView {

        // MARK: - Private properties

        private let shouldChangeLayoutWhenCompact: Bool
        private lazy var sectionsStackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)

        // MARK: - Init

        init(
            sections: [ViewModel.Section],
            shouldChangeLayoutWhenCompact: Bool,
            sectionDelegate: MotorSidebarSectionViewDelegate
        ) {
            self.shouldChangeLayoutWhenCompact = shouldChangeLayoutWhenCompact
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(sections: sections, sectionDelegate: sectionDelegate)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(sections: [ViewModel.Section], sectionDelegate: MotorSidebarSectionViewDelegate) {
            clipsToBounds = true

            addSubview(sectionsStackView)
            sectionsStackView.fillInSuperview()

            sections.enumerated().forEach { index, section in
                if index != 0 {
                    sectionsStackView.addArrangedSubview(.hairlineView())
                }

                let sectionView = SectionView(
                    section: section,
                    shouldChangeLayoutWhenCompact: shouldChangeLayoutWhenCompact,
                    delegate: sectionDelegate
                )
                sectionsStackView.addArrangedSubview(sectionView)
            }
        }

        // MARK: - Overrides

        override func layoutSubviews() {
            super.layoutSubviews()

            layer.borderColor = .borderDefault
            switch traitCollection.horizontalSizeClass {
            case .regular:
                layer.cornerRadius = 8
                layer.borderWidth = 1
            default:
                if shouldChangeLayoutWhenCompact {
                    layer.cornerRadius = 0
                    layer.borderWidth = 0
                } else {
                    layer.cornerRadius = 8
                    layer.borderWidth = 1
                }
            }
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
