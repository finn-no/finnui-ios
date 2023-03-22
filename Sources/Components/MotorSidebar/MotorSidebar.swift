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

        private var headerView: InnerSectionHeader?
        private var ribbonView: RibbonView?
        private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var bodyStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var bulletPointsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var buttonStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

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
                self.ribbonView = ribbonView

                addSubview(ribbonView)
                NSLayoutConstraint.activate([
                    ribbonView.topAnchor.constraint(equalTo: topAnchor),
                    ribbonView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    ribbonView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                    ribbonView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
                ])
            }

            if let header = section.header {
                let headerView = InnerSectionHeader(
                    title: header.title,
                    icon: header.icon,
                    isExpandable: section.isExpandable,
                    isExpanded: section.isExpanded ?? true
                )
                self.headerView = headerView

                addSubview(headerView)
                NSLayoutConstraint.activate([
                    headerView.topAnchor.constraint(equalTo: ribbonView?.bottomAnchor ?? topAnchor),
                    headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    headerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                    headerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
                ])
            }

            if !section.content.isEmpty {
                let subviews = section.content.map { SectionBodyView(body: $0) }
                bodyStackView.addArrangedSubviews(subviews)
                contentStackView.addArrangedSubview(bodyStackView)
            }

            if !section.bulletPoints.isEmpty {
                let subviews = section.bulletPoints.map { BulletPoint(text: $0) }
                bulletPointsStackView.addArrangedSubviews(subviews)
                contentStackView.addArrangedSubview(bulletPointsStackView)
            }

            if !section.buttons.isEmpty {
                let buttons = section.buttons.map { Button.create(from: $0) }
                buttonStackView.addArrangedSubviews(buttons)
                contentStackView.addArrangedSubview(buttonStackView)
            }

            addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentStackView.topAnchor.constraint(
                    equalTo: ribbonView?.bottomAnchor ?? headerView?.bottomAnchor ?? topAnchor,
                    constant: ribbonView != nil ? 0 : .spacingS
                ),
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
                contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS),
            ])
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
    class SectionBodyView: UIView {

        // MARK: - Private properties

        private lazy var textLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)

        // MARK: - Init

        init(body: ViewModel.Body) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(body: body)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(body: ViewModel.Body) {
            let attributedString = NSMutableAttributedString(string: body.text)

            if let inlineImage = body.inlineImage {
                let imageAttachment = ImageAttachment(
                    image: inlineImage.image.withRenderingMode(.alwaysOriginal),
                    baselineOffset: inlineImage.baselineOffset
                )
                let imageString = NSAttributedString(attachment: imageAttachment)
                attributedString.append(imageString)
            }

            textLabel.attributedText = attributedString
            addSubview(textLabel)
            textLabel.fillInSuperview()
        }
    }
}

/// This class resizes an image so it can be placed inline with other text in an `NSAttributedString`.
/// The image will be resized to match the height of the font's `capHeight` and be placed so the bottom of the image is on the same height as the text's baseline.
/// The font will be read from what you have on either the `Label` or the font attribute you've set on your `NSAttributedString`.
///
/// If you want to push the image further down, i.e. if the image contains letters and you want that text's baseline to be equal to that of the `NSAttributedString`, you
/// need to specify the height of the "overflow" below the image's baseline by using the `baselineOffset` parameter when instantiating this class.
/// Be aware that this will effectively make the image larger than the font's `capHeight`, but visually they'll be equal in size and the baselines will be equal.
class ImageAttachment: NSTextAttachment {

    // MARK: - Private properties

    private var baselineOffset: CGFloat = 0

    // MARK: - Init

    convenience init(image: UIImage, baselineOffset: CGFloat) {
        self.init()
        self.image = image
        self.baselineOffset = baselineOffset
    }

    // MARK: - Overrides

    @available(iOS 15.0, *)
    override func attachmentBounds(
        for attributes: [NSAttributedString.Key: Any],
        location: NSTextLocation,
        textContainer: NSTextContainer?,
        proposedLineFragment: CGRect,
        position: CGPoint
    ) -> CGRect {
        guard let image = image else {
            return .zero
        }

        // Read out the font specified. This is either set on the label or `NSAttributedString` this is inserted into.
        let font: UIFont = (attributes[.font] as? UIFont) ?? .body

        // This value is the total amount of space available, but we need the image only to match the height
        // of the label/font so we need to figure out the inset from the top we have to subtract.
        let proposedHeight = proposedLineFragment.size.height

        let inset = proposedHeight - font.capHeight - baselineOffset
        let labelHeight = proposedHeight - inset

        // The image will most probably not have the same height as `labelHeight`, so we need to find a value to
        // use for scaling the image.
        let scale: CGFloat = labelHeight / image.size.height

        return CGRect(
            origin: CGPoint(
                x: 0,
                y: -baselineOffset * scale
            ),
            size: CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )
        )
    }
}

extension MotorSidebar {
    class InnerSectionHeader: UIView {

        // MARK: - Private properties

        private let isExpandable: Bool
        private var isExpanded: Bool
        private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, withAutoLayout: true)
        private lazy var titleLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)

        private lazy var iconImageView: UIImageView = {
            let view = UIImageView(withAutoLayout: true)
            view.tintColor = .textPrimary
            view.contentMode = .scaleAspectFit
            return view
        }()

        private lazy var chevronImageView: UIView = {
            let view = UIImageView(withAutoLayout: true)
            view.image = UIImage(systemName: "chevron.up")
            view.tintColor = .textPrimary
            view.contentMode = .scaleAspectFit
            return view
        }()

        // MARK: - Init

        init(title: String, icon: UIImage, isExpandable: Bool, isExpanded: Bool) {
            self.isExpandable = isExpandable
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

            stackView.addArrangedSubviews([iconImageView, titleLabel, UIView()])

            if isExpandable {
                stackView.addArrangedSubview(chevronImageView)
            }

            addSubview(stackView)
            stackView.fillInSuperview(insets: UIEdgeInsets(top: .spacingS, leading: .spacingM, bottom: -.spacingS, trailing: -.spacingM))

            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: .spacingL),
                iconImageView.heightAnchor.constraint(equalToConstant: .spacingL),
                chevronImageView.widthAnchor.constraint(equalToConstant: .spacingL),
                chevronImageView.heightAnchor.constraint(equalToConstant: .spacingL),
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

// MARK: - Private extension

extension Button {
    static func create(from viewModel: MotorSidebar.ViewModel.Button) -> Button {
        let button = Button(style: viewModel.kind.buttonStyle, size: .normal, withAutoLayout: true)
        button.setTitle(viewModel.text, for: .normal)
        return button
    }
}
