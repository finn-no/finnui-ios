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
        if imagePath == "FINN-LOGO" {
            completion(UIImage(named: .finnLogoLarge))
            return
        }

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

    func realestateSoldStateViewDidSelectCompanyProfileCtaButton(_ view: RealestateSoldStateView) {
        print("👉 Did select company profile CTA button.")
    }

    func realestateSoldStateView(_ view: RealestateSoldStateView, didTapCompanyProfileButtonWithIdentifier identifier: String?, url: URL) {
        print("👉 Did select company profile button with identifier '\(identifier ?? "??")'")
    }
}

// MARK: - Private extensions

private extension RealestateSoldStateModel {
    static var demoModel: RealestateSoldStateModel {
        RealestateSoldStateModel(
            agentProfile: .demoModel,
            questionForm: .demoModel,
            companyProfile: .demoModel
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
            phoneNumber: "123 45 678"
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

extension CompanyProfileModel {
    static var demoModel: CompanyProfileModel {
        CompanyProfileModel(
            imageUrl: "FINN-LOGO",
            slogan: "Vi selger boligen din – raskt og enkelt",
            buttonLinks: [
                .init(identifier: "1", title: "Hjemmeside"),
                .init(identifier: "2", title: "Flere annonser fra oss"),
                .init(identifier: "3", title: "Skal du selge bolig?"),
            ],
            ctaButtonTitle: "Be om verdivurdering"
        )
    }
}

private extension LinkButtonViewModel {
    private static var demoStyle: Button.Style {
        Button.Style.flat.overrideStyle(margins: UIEdgeInsets(vertical: .spacingS, horizontal: .zero), smallFont: .body)
    }

    init(identifier: String, title: String) {
        self.init(
            buttonIdentifier: identifier,
            buttonTitle: title,
            linkUrl: URL(string: "https://finn.no")!,
            isExternal: false,
            buttonStyle: Self.demoStyle,
            buttonSize: .small
        )
    }
}