import UIKit
import FinniversKit

public class RealestateSoldStateView: UIView {

    // MARK: - Public properties

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)

    private lazy var questionFormView: QuestionFormView = {
        let view = QuestionFormView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: "Hva lurer du på?", questions: [
            .init(kind: .provided, title: "Hva ble boligen solgt for?", isSelected: true),
            .init(kind: .provided, title: "Hvor mange var det som kom på visning?", isSelected: false),
            .init(kind: .provided, title: "Hva kan man forvente av en budrunde?", isSelected: false),
            .init(kind: .provided, title: "Kan jeg få en verdivurdering av min bolig?", isSelected: false),
            .init(kind: .userFreetext, title: "Annet", isSelected: true, value: "Long text\nSeveral lines\nAnother line"),
        ])
        return view
    }()

    private lazy var userContactMethodView: UserContactInformationView = {
        let view = UserContactInformationView(withAutoLayout: true)
        view.configure(
            with: "Hvordan kan vi kontakte deg?",
            contactMethodModels: [
                .init(
                    identifier: "1",
                    name: "Svar meg på mail",
                    textFieldType: .email,
                    textFieldPlaceholder: "Legg inn din mail-adresse"
                ),
                .init(
                    identifier: "2",
                    name: "Svar meg på telefon",
                    textFieldType: .phoneNumber,
                    textFieldPlaceholder: "Legg inn ditt telefonnummer"
                ),
            ]
        )
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubviews([questionFormView, userContactMethodView])
        addSubview(stackView)
        stackView.fillInSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16))
    }
}

// MARK: - QuestionFormViewDelegate

extension RealestateSoldStateView: QuestionFormViewDelegate {
    func questionFormViewDidToggleTextView(_ view: QuestionFormView) {
        print("✒️ Did toggle textView")
    }
}
