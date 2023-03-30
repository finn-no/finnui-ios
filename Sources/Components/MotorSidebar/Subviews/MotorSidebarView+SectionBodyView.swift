import FinniversKit

extension MotorSidebarView {
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
            textLabel.accessibilityLabel = body.accessibilityLabel

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
