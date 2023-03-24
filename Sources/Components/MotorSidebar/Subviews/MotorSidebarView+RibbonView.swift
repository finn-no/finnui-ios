import FinniversKit

extension MotorSidebarView {
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
