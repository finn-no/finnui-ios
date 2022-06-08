import UIKit
import FinniversKit

public final class TJTAccordionView: UIStackView {
    private lazy var headerStackView: UIStackView = {
        let header = UIStackView(axis: .horizontal)
        header.spacing = .spacingM
        header.directionalLayoutMargins = .init(
            top: .spacingM,
            leading: .spacingM,
            bottom: .spacingM,
            trailing: .spacingM
        )
        header.isLayoutMarginsRelativeArrangement = true
        return header
    }()

    private lazy var headerIcon: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var headerTitle: Label = {
        let label = Label(style: .bodyStrong)
        label.textColor = .licorice
        return label
    }()

    private lazy var chevron: UIImageView = {
        let bundle = Bundle(for: Label.self)
        let image = UIImage(systemName: "chevron.down")
        let chevron = UIImageView(image: image)
        chevron.contentMode = .scaleAspectFit
        return chevron
    }()

    private(set) lazy var contentView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.directionalLayoutMargins = .init(
            top: .spacingM,
            leading: .spacingM,
            bottom: .spacingM,
            trailing: .spacingM
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        axis = .vertical
        
        headerIcon.image = UIImage(systemName: "shippingbox")
        
        headerIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        headerIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        chevron.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        headerStackView.addArrangedSubviews([
            headerIcon,
            headerTitle,
            chevron
        ])
        
        let separatorStackView = UIStackView(axis: .horizontal)
        separatorStackView.directionalLayoutMargins = .init(
            top: .zero,
            leading: .spacingM + 24 + .spacingM,
            bottom: .zero,
            trailing: .zero
        )
        separatorStackView.isLayoutMarginsRelativeArrangement = true
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .blueGray400
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorStackView.addArrangedSubview(view)
        
        
        addArrangedSubview(headerStackView)
        headerTitle.text = "dasdadsa"
        addArrangedSubview(separatorStackView)
        addArrangedSubview(contentView)
        
        let label = Label(style: .body)
        label.numberOfLines = 0
        label.text = "askjdhjaso dias doias iohud ahsdadas dhdiasu uhdais duias diuas dad"
        contentView.addArrangedSubview(label)
    }
}
