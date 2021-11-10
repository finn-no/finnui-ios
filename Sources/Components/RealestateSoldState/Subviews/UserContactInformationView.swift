import UIKit
import FinniversKit

class UserContactInformationView: UIView {

    // MARK: - Internal methods

    private var selectedContactMethod: UserContactMethodSelectionModel? {
        contactMethodModels.selectedModel
    }

    // MARK: - Private properties

    private var contactMethodModels = [UserContactMethodSelectionModel]()
    private var textField: TextField?
    private lazy var titleLabel = Label(style: .title3Strong, withAutoLayout: true)
    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var contactMethodStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentStackView.addArrangedSubviews([titleLabel, contactMethodStackView])
        addSubview(contentStackView)
        contentStackView.fillInSuperview()
    }

    // MARK: - Internal methods

    func configure(with title: String, contactMethodModels: [UserContactMethodSelectionModel]) {
        titleLabel.text = title
        self.contactMethodModels = contactMethodModels

        contactMethodStackView.removeArrangedSubviews()

        // Make sure at only one contact method is marked as selected by default.
        if contactMethodModels.selectedModel == nil {
            contactMethodModels.first?.isSelected = true
        } else if contactMethodModels.filter({ $0.isSelected }).count > 1 {
            contactMethodModels.forEach { $0.isSelected = false }
            contactMethodModels.first?.isSelected = true
        }

        let contactMethodViews = contactMethodModels.map { UserContactMethodSelectionView(viewModel: $0, delegate: self) }
        contactMethodStackView.addArrangedSubviews(contactMethodViews)

        createOrReplaceTextField()
    }

    // MARK: - Private methods

    private func createOrReplaceTextField() {
        if let textField = textField {
            contentStackView.removeArrangedSubview(textField)
            textField.removeFromSuperview()
            self.textField = nil
        }

        if let textField = TextField(viewModel: selectedContactMethod) {
            textField.delegate = self
            contentStackView.addArrangedSubview(textField)
            self.textField = textField
        }
    }
}

// MARK: - UserContactMethodSelectionViewDelegate

extension UserContactInformationView: UserContactMethodSelectionViewDelegate {
    func userContactMethodSelectionViewWasSelected(_ selectedView: UserContactMethodSelectionView) {
        contactMethodStackView.arrangedSubviews.forEach {
            guard let subview = $0 as? UserContactMethodSelectionView else { return }

            if subview.viewModel.isSelected || subview == selectedView {
                subview.viewModel.isSelected.toggle()
                subview.updateView()
            }
        }

        createOrReplaceTextField()
    }
}

// MARK: - TextFieldDelegate

extension UserContactInformationView: TextFieldDelegate {
    func textFieldDidChange(_ textField: TextField) {
        contactMethodModels.selectedModel?.value = textField.text
    }
}

// MARK: - Private extensions

private extension TextField {
    convenience init?(viewModel: UserContactMethodSelectionModel?) {
        guard let viewModel = viewModel else { return nil }
        self.init(inputType: viewModel.textFieldType)
        translatesAutoresizingMaskIntoConstraints = false
        text = viewModel.value

        // I have no idea why, but this doesn't work if set within the init. I need to defer this call.
        defer { placeholderText = viewModel.textFieldPlaceholder }
    }
}

extension Array where Element == UserContactMethodSelectionModel {
    var selectedModel: UserContactMethodSelectionModel? {
        first(where: { $0.isSelected })
    }
}
