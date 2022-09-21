import UIKit
import FinniversKit

protocol UserContactInformationViewDelegate: AnyObject {
    func userContactInformationViewDidSwitchContactMethod(_ view: UserContactInformationView)
    func userContactInformationViewDidUpdateTextField(_ view: UserContactInformationView)
}

class UserContactInformationView: UIView {

    // MARK: - Internal methods

    private(set) var enteredUserContactName: String?

    var selectedContactMethod: UserContactMethodSelectionModel? {
        contactMethodModels.selectedModel
    }

    var isInputValid: Bool {
        if selectedContactMethod is UserContactMethodSelectionModel.Phone {
            return phoneNumberTextField.isValid
        }
        return true
    }

    // MARK: - Private properties

    private weak var delegate: UserContactInformationViewDelegate?
    private let contactMethodEmail: UserContactMethodSelectionModel.Email
    private let contactMethodPhone: UserContactMethodSelectionModel.Phone
    private let userContactName: QuestionFormViewModel.UserContactName
    private var hasDoneInitialSetup = false
    private lazy var titleLabel = Label(style: .title3Strong, withAutoLayout: true)
    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var contactMethodStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
    private lazy var contactMethodTitleLabel = Label(style: .captionStrong, withAutoLayout: true)
    private lazy var userContactNameTitleLabel = Label(style: .captionStrong, withAutoLayout: true)
    private lazy var emailAddressView = EmailAddressView(viewModel: contactMethodEmail, withAutoLayout: true)
    private lazy var phoneNumberTextField = TextField(viewModel: contactMethodPhone, delegate: self)
    private lazy var userContactNameTextField = TextField(viewModel: userContactName, delegate: self)

    private var contactMethodModels: [UserContactMethodSelectionModel] {
        [contactMethodEmail, contactMethodPhone]
    }

    // MARK: - Init

    init(
        contactMethod: QuestionFormViewModel.ContactMethod,
        userContactName : QuestionFormViewModel.UserContactName,
        delegate: UserContactInformationViewDelegate,
        withAutoLayout: Bool
    ) {
        contactMethodEmail = contactMethod.emailMethod
        contactMethodPhone = contactMethod.phoneMethod
        self.userContactName = userContactName
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        setup(title: contactMethod.title)
        enteredUserContactName = userContactName.initialValue
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(title: String) {
        emailAddressView.isHidden = true
        phoneNumberTextField.isHidden = true

        contentStackView.addArrangedSubviews([
            titleLabel,
            contactMethodStackView,
            contactMethodTitleLabel,
            emailAddressView,
            phoneNumberTextField,
            userContactNameTitleLabel,
            userContactNameTextField
        ])

        addSubview(contentStackView)
        contentStackView.fillInSuperview()
        contentStackView.setCustomSpacing(.spacingXS, after: contactMethodTitleLabel)
        contentStackView.setCustomSpacing(.spacingXS, after: userContactNameTitleLabel)

        titleLabel.text = title
        userContactNameTitleLabel.text = userContactName.title

        // Make sure at only one contact method is marked as selected by default.
        if contactMethodModels.selectedModel == nil {
            contactMethodModels.first?.isSelected = true
        } else if contactMethodModels.filter({ $0.isSelected }).count > 1 {
            contactMethodModels.forEach { $0.isSelected = false }
            contactMethodModels.first?.isSelected = true
        }

        let contactMethodViews = contactMethodModels.map { UserContactMethodSelectionView(viewModel: $0, delegate: self) }
        contactMethodStackView.addArrangedSubviews(contactMethodViews)

        presentSelectedContactMethodView()
        hasDoneInitialSetup = true
    }

    // MARK: - Private methods

    private func presentSelectedContactMethodView() {
        contactMethodTitleLabel.text = selectedContactMethod?.name

        if selectedContactMethod is UserContactMethodSelectionModel.Email {
            phoneNumberTextField.isHidden = true
            emailAddressView.isHidden = false
        } else if selectedContactMethod is UserContactMethodSelectionModel.Phone {
            emailAddressView.isHidden = true
            phoneNumberTextField.isHidden = false
        }

        if hasDoneInitialSetup {
            delegate?.userContactInformationViewDidSwitchContactMethod(self)
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

        presentSelectedContactMethodView()
    }
}

// MARK: - TextFieldDelegate

extension UserContactInformationView: TextFieldDelegate {
    func textFieldDidChange(_ textField: TextField) {
        if textField == phoneNumberTextField {
            contactMethodPhone.value = textField.text
            delegate?.userContactInformationViewDidUpdateTextField(self)
        } else if textField == userContactNameTextField {
            enteredUserContactName = textField.text
        }
    }
}

// MARK: - Private extensions

private extension TextField {
    convenience init(viewModel: UserContactMethodSelectionModel.Phone, delegate: TextFieldDelegate) {
        self.init(inputType: .phoneNumber)
        translatesAutoresizingMaskIntoConstraints = false
        text = viewModel.value
        self.delegate = delegate
        textField.placeholder = viewModel.textFieldPlaceholder
        configureColors()
    }

    convenience init(viewModel: QuestionFormViewModel.UserContactName, delegate: TextFieldDelegate) {
        self.init(inputType: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        text = viewModel.initialValue
        self.delegate = delegate
        textField.placeholder = viewModel.title
        configureColors()
    }

    func configureColors() {
        configure(textFieldBackgroundColor: .bgPrimary)
        configureBorder(radius: 4, width: 1, color: .dynamicColor(defaultColor: .sardine, darkModeColor: .darkSardine))
    }
}

private extension Array where Element == UserContactMethodSelectionModel {
    var selectedModel: UserContactMethodSelectionModel? {
        first(where: { $0.isSelected })
    }
}

// MARK: - Private types

private class EmailAddressView: UIView {

    // MARK: - Private properties

    private let viewModel: UserContactMethodSelectionModel.Email
    private lazy var emailLabel = Label(style: .body, withAutoLayout: true)
    private lazy var dislaimerLabel = Label(style: .body, withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    // MARK: - Init

    init(viewModel: UserContactMethodSelectionModel.Email, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        emailLabel.text = viewModel.value
        dislaimerLabel.text = viewModel.disclaimerText

        stackView.addArrangedSubviews([emailLabel, dislaimerLabel])
        addSubview(stackView)
        stackView.fillInSuperview()
    }
}
