import FinniversKit

protocol MotorSidebarSectionViewDelegate: AnyObject {
    func motorSidebarSectionView(
        _ sectionView: MotorSidebarView.SectionView,
        didSelectButton viewModel: MotorSidebarView.ViewModel.Button
    )

    func motorSidebarSectionViewDidToggleExpand(_ sectionView: MotorSidebarView.SectionView, isExpanded: Bool)
}

extension MotorSidebarView {
    class SectionView: UIView {
        enum TopViewKind {
            case ribbon
            case header
            case none
        }

        // MARK: - Private properties

        private weak var delegate: MotorSidebarSectionViewDelegate?
        private let section: ViewModel.Section
        private let shouldChangeLayoutWhenCompact: Bool
        private var topViewKind = TopViewKind.none
        private lazy var contentView = SectionContentView(section: section, delegate: self)
        private lazy var contentLayoutGuide = UILayoutGuide()
        private lazy var topStackView = UIStackView(axis: .horizontal, spacing: 0, withAutoLayout: true)

        // Constraints.
        private lazy var bottomAnchorExpandedConstraint = bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: .spacingM)
        private lazy var bottomAnchorCollapsedConstraint = bottomAnchor.constraint(equalTo: contentLayoutGuide.topAnchor)

        // MARK: - Init

        init(
            section: ViewModel.Section,
            shouldChangeLayoutWhenCompact: Bool,
            delegate: MotorSidebarSectionViewDelegate
        ) {
            self.section = section
            self.shouldChangeLayoutWhenCompact = shouldChangeLayoutWhenCompact
            self.delegate = delegate
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup()
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup() {
            clipsToBounds = true

            // We will only keep one view at the top. Either it'll have a ribbon, or it'll have a header.
            if let ribbon = section.ribbon {
                let ribbonView = RibbonView(ribbon: ribbon)

                topViewKind = .ribbon
                topStackView.addArrangedSubviews([UIView(withAutoLayout: true), ribbonView])
            } else if let header = section.header {
                let headerView = SectionHeaderView(
                    title: header.title,
                    icon: header.icon,
                    shouldChangeLayoutWhenCompact: shouldChangeLayoutWhenCompact,
                    isExpandable: section.isExpandable,
                    isExpanded: section.isExpanded
                )
                headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped)))

                topViewKind = .header
                topStackView.addArrangedSubview(headerView)
            }

            addLayoutGuide(contentLayoutGuide)
            addSubview(topStackView)
            addSubview(contentView)

            NSLayoutConstraint.activate([
                topStackView.topAnchor.constraint(equalTo: topAnchor),
                topStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                topStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

                contentLayoutGuide.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
                contentLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),

                contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor)
            ])

            configurePresentation()
            updateStateConstraints()
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
                if topViewKind == .ribbon {
                    topStackView.arrangedSubviews.forEach { $0.isHidden = false }
                }

                contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(
                    top: topViewKind == .none ? .spacingM : 0,
                    leading: .spacingM,
                    bottom: 0,
                    trailing: .spacingM
                )
            default:
                if topViewKind == .ribbon {
                    topStackView.arrangedSubviews.forEach { $0.isHidden = true }
                }

                if shouldChangeLayoutWhenCompact {
                    contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(all: 0)
                } else {
                    contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(
                        top: topViewKind == .header ? .spacingM : 0,
                        leading: .spacingM,
                        bottom: 0,
                        trailing: .spacingM
                    )
                }
            }
            layoutIfNeeded()
        }

        private func updateStateConstraints() {
            if section.isExpanded {
                bottomAnchorCollapsedConstraint.isActive = false
                bottomAnchorExpandedConstraint.isActive = true
            } else {
                bottomAnchorExpandedConstraint.isActive = false
                bottomAnchorCollapsedConstraint.isActive = true
            }
            layoutIfNeeded()
        }

        // MARK: - Actions

        @objc private func headerTapped(sender: UITapGestureRecognizer) {
            section.isExpanded.toggle()
            updateStateConstraints()

            if let headerView = sender.view as? SectionHeaderView {
                headerView.updateExpandedState(isExpanded: section.isExpanded)
            }

            delegate?.motorSidebarSectionViewDidToggleExpand(self, isExpanded: section.isExpanded)
        }
    }
}

// MARK: - MotorSidebarSectionContentViewDelegate

extension MotorSidebarView.SectionView: MotorSidebarSectionContentViewDelegate {
    func motorSidebarSectionContentView(
        _ sectionView: MotorSidebarView.SectionContentView,
        didSelectButton viewModel: MotorSidebarView.ViewModel.Button
    ) {
        delegate?.motorSidebarSectionView(self, didSelectButton: viewModel)
    }
}
