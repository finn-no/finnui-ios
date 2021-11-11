import UIKit
import FinniversKit
import FinnUI

class RealestateSoldStateDemoView: UIView {
    private lazy var scrollView = UIScrollView(withAutoLayout: true)
    private lazy var realestateSoldStateView: RealestateSoldStateView = {
        let view = RealestateSoldStateView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: .demoModel, remoteImageViewDataSource: self)
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

// MARK: - RemoteImageViewDataSource

extension RealestateSoldStateDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
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

// MARK: - Private extensions

private extension RealestateSoldStateModel {
    static var demoModel: RealestateSoldStateModel {
        RealestateSoldStateModel(
            agentProfile: .demoModel,
            questionForm: .demoModel
        )
    }
}

private extension AgentProfileModel {
    static var demoModel: AgentProfileModel {
        AgentProfileModel(
            title: "Ansvarlig megler for dette salget",
            agentName: "Navn Navnesen",
            agentJobTitle: "Eiendomsmegler / Partner",
            imageUrl: "https://ih1.redbubble.net/image.1257154546.3057/flat,128x128,075,t-pad,128x128,f8f8f8.jpg",
            phoneNumber: "123 45 678",
            email: "navn.navnesen@megler.no"
        )
    }
}

private extension QuestionFormViewModel {
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
