import UIKit
import FinniversKit
import FinnUI

class RealestateSoldStateDemoView: UIView {
    private lazy var scrollView = UIScrollView(withAutoLayout: true)
    private lazy var realestateSoldStateView: RealestateSoldStateView = {
        let view = RealestateSoldStateView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: .demoModel)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        scrollView.alwaysBounceVertical = true

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(realestateSoldStateView)

        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            realestateSoldStateView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            realestateSoldStateView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            realestateSoldStateView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            realestateSoldStateView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - RealestateSoldStateViewDelegate

extension RealestateSoldStateDemoView: RealestateSoldStateViewDelegate {
    func realestateSoldStateView(_ view: RealestateSoldStateView, didSubmitForm form: RealestateSoldStateQuestionFormSubmit) {
        print("""
              ✅ Did submit form!
              \tContact identifier: '\(form.contactMethodIdentifier)'
              \tContact value: '\(form.contactMethodValue)'
              \tSelected questions:
              \t\t\(form.questions.joined(separator: "\n\t\t"))
              """)
    }
}

extension QuestionFormViewModel {
    static var demoModel: QuestionFormViewModel {
        QuestionFormViewModel(
            questionsTitle: "Hva lurer du på?",
            questions: [
                .init(kind: .provided, title: "Hva ble boligen solgt for?", isSelected: true),
                .init(kind: .provided, title: "Hvor mange var det som kom på visning?", isSelected: false),
                .init(kind: .provided, title: "Hva kan man forvente av en budrunde?", isSelected: false),
                .init(kind: .provided, title: "Kan jeg få en verdivurdering av min bolig?", isSelected: false),
                .init(kind: .userFreetext, title: "Annet", isSelected: true, value: "Long text\nSeveral lines\nAnother line"),
            ],
            contactMethodTitle: "Hvordan kan vi kontakte deg?",
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
            ],
            submitDisclaimer: "Ved å trykke \"Send skjema\" samtykker du til at FINN kan sende dine opplysninger fra skjema over til ansvarlig megler for denne annonsen.",
            submitButtonTitle: "Send skjema"
        )
    }
}
