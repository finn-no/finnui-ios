import UIKit
import FinniversKit

public protocol MotorSidebarDelegate: AnyObject {
    func motorSidebar(_ view: MotorSidebar, didSelectButtonWithIdentifier identifier: String?, urlString: String?)
    func motorSidebar(_ view: MotorSidebar, didToggleExpandOnSectionAt sectionIndex: Int, isExpanded: Bool)
}

public class MotorSidebar: UIView {

    // MARK: - Public properties

    public weak var delegate: MotorSidebarDelegate?

    // MARK: - Private properties

    private let viewModel: ViewModel

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    // MARK: - Init

    public init(
        viewModel: ViewModel,
        delegate: MotorSidebarDelegate,
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
        stackView.addArrangedSubview(SectionsContainer(sections: viewModel.mainSections))

        if let secondarySection = viewModel.secondary {
            stackView.addArrangedSubview(SectionsContainer(sections: [secondarySection]))
        }

        addSubview(stackView)
        stackView.fillInSuperview()
    }
}

extension MotorSidebar {
    class SectionsContainer: UIView {

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

            sections.enumerated().forEach { index, section in
                if index != 0 {
                    sectionsStackView.addArrangedSubview(.hairlineView())
                }

                sectionsStackView.addArrangedSubview(InnerSection(section: section))
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

extension MotorSidebar {
    class InnerSection: UIView {

        // MARK: - Internal properties



        // MARK: - Private properties

        private var header: InnerSectionHeader?
        private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var bulletPointsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var buttonStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

        // MARK: - Init

        init(section: ViewModel.Section) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(section: section)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(section: ViewModel.Section) {
            if let ribbon = section.ribbon {
                let ribbonView = RibbonView(ribbon: ribbon)

                addSubview(ribbonView)
                NSLayoutConstraint.activate([
                    ribbonView.topAnchor.constraint(equalTo: topAnchor),
                    ribbonView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    ribbonView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                    ribbonView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
                ])
            }

            if !section.bulletPoints.isEmpty {
                let subviews = section.bulletPoints.map { BulletPoint(text: $0) }
                bulletPointsStackView.addArrangedSubviews(subviews)
                contentStackView.addArrangedSubview(bulletPointsStackView)
            }

            addSubview(contentStackView)
            contentStackView.fillInSuperview(insets: .init(top: .spacingS, leading: .spacingS, bottom: -.spacingS, trailing: -.spacingS))
        }
    }
}

extension MotorSidebar {
    class RibbonView: UIView {

        // MARK: - Private properties

        private lazy var textLabel = Label(style: .captionStrong, numberOfLines: 0, textColor: .gray700, withAutoLayout: true)

        // MARK: - Init

        init(ribbon: ViewModel.Ribbon) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(ribbon: ribbon)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(ribbon: ViewModel.Ribbon) {
            textLabel.text = ribbon.title
            backgroundColor = ribbon.backgroundColor

            addSubview(textLabel)
            textLabel.fillInSuperview(insets: .init(top: .spacingS, leading: .spacingM, bottom: -.spacingS, trailing: -.spacingM))

            layer.maskedCorners = [.layerMinXMaxYCorner]
            layer.cornerRadius = 8
        }
    }
}

extension MotorSidebar {
    class InnerSectionHeader: UIView {

        // MARK: - Private properties

        private var isExpanded: Bool
        private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, withAutoLayout: true)
        private lazy var titleLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)

        private lazy var iconImageView: UIImageView = {
            let view = UIImageView(withAutoLayout: true)
            view.tintColor = .textPrimary
            view.contentMode = .scaleAspectFit
            return view
        }()

        private lazy var expandButton: UIView = {
            let view = UIImageView(withAutoLayout: true)
            view.tintColor = .textPrimary
            view.contentMode = .scaleAspectFit
            return view
        }()

        // MARK: - Init

        init(title: String, icon: UIImage, isExpanded: Bool) {
            self.isExpanded = isExpanded
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(title: title, icon: icon)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(title: String, icon: UIImage) {
            titleLabel.text = title
            iconImageView.image = icon

            stackView.addArrangedSubviews([iconImageView, titleLabel, expandButton])
            addSubview(stackView)
            stackView.fillInSuperview(insets: UIEdgeInsets(vertical: .spacingS, horizontal: .spacingM))

            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: .spacingL),
                iconImageView.heightAnchor.constraint(equalToConstant: .spacingL),
                expandButton.widthAnchor.constraint(equalToConstant: .spacingL),
                expandButton.heightAnchor.constraint(equalToConstant: .spacingL),
            ])
        }
    }
}

extension MotorSidebar {
    class BulletPoint: UIView {

        // MARK: - Private properties

        private lazy var valueLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)
        private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, withAutoLayout: true)

        private lazy var bulletImageView: UIImageView = {
            let image = UIImage(systemName: "circle.fill")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .blueGray300
            return imageView
        }()

        // MARK: - Init

        init(text: String) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(text: text)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(text: String) {
            valueLabel.text = text

            stackView.addArrangedSubviews([bulletImageView, valueLabel])
            addSubview(stackView)
            stackView.fillInSuperview()

            NSLayoutConstraint.activate([
                bulletImageView.widthAnchor.constraint(equalToConstant: 12),
                bulletImageView.heightAnchor.constraint(equalToConstant: 12),
            ])
        }
    }
}
