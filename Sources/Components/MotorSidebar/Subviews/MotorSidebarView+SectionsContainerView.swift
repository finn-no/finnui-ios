import FinniversKit

extension MotorSidebarView {
    class SectionsContainerView: UIView {

        // MARK: - Private properties

        private lazy var sectionsStackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)

        // MARK: - Init

        init(sections: [ViewModel.Section]) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(sections: sections)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(sections: [ViewModel.Section]) {
            clipsToBounds = true
            layer.borderWidth = 1
            layer.cornerRadius = 8

            addSubview(sectionsStackView)
            sectionsStackView.fillInSuperview()

            let numberOfSections = sections.count
            sections.enumerated().forEach { index, section in
                if index != 0 {
                    sectionsStackView.addArrangedSubview(.hairlineView())
                }

                sectionsStackView.addArrangedSubview(SectionView(section: section, position: .init(index: index, numberOfSections: numberOfSections)))
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
