import Combine
import FinniversKit
import UIKit

public final class FiksFerdigSafePaymentInfoView: UIView {
    private let viewModel: FiksFerdigSafePaymentInfoViewModel
    private let simpleIndicatorProvider = SimpleTimeLineIndicatorProvider(font: .caption)

    private lazy var headerIcon: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textPrimary
        imageView.image = viewModel.icon
        return imageView
    }()

    private lazy var headerTitle: Label = {
        let label = Label(style: .bodyStrong)
        label.numberOfLines = 0
        label.text = viewModel.title
        return label
    }()

    private lazy var timeLineView: TimeLineView = {
        let timeLineView = TimeLineView(
            items: viewModel.timeLineItems,
            itemIndicatorProvider: simpleIndicatorProvider,
            withAutoLayout: true
        )
        timeLineView.layoutIfNeeded()
        return timeLineView
    }()

    private lazy var contentView: UIStackView = {
        return UIStackView(axis: .vertical, spacing: .spacingM, alignment: .leading)
    }()

    private lazy var titleView: UIStackView = {
        return UIStackView(axis: .horizontal, spacing: .spacingM, alignment: .leading)
    }()

    public init(
        viewModel: FiksFerdigSafePaymentInfoViewModel,
        withAutoLayout: Bool = false
    ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        titleView.addArrangedSubviews([
            headerIcon,
            headerTitle
        ])

        contentView.addArrangedSubviews([
            titleView,
            timeLineView
        ])

        addSubview(contentView)
        contentView.fillInSuperview()
    }
}
