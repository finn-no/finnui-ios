import UIKit
import FinniversKit
import FinnUI

class RealestateSoldStateDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Default - expanded") { [weak self] in
            self?.setupDemoView(with: .demoModel, isExpanded: true)
        },
        .init(title: "Default - collapsed") { [weak self] in
            self?.setupDemoView(with: .demoModel, isExpanded: false)
        },
        .init(title: "Without contact information - collapsed") { [weak self] in
            self?.setupDemoView(with: .demoModelWithoutContactInfo, isExpanded: false)
        },
        .init(title: "Form submitted") { [weak self] in
            self?.setupDemoView(with: .demoModel, isExpanded: false, isFormSubmitted: true)
        },
    ]

    private var realestateSoldStateView: RealestateSoldStateView?
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        scrollView.alwaysBounceVertical = true

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
    }

    // MARK: - Private methods

    private func setupDemoView(with viewModel: RealestateSoldStateModel, isExpanded: Bool, isFormSubmitted: Bool = false) {
        if let oldView = realestateSoldStateView {
            oldView.removeFromSuperview()
            realestateSoldStateView = nil
        }

        let view = RealestateSoldStateView(viewModel: viewModel, remoteImageViewDataSource: self, withAutoLayout: true)
        view.isExpanded = isExpanded
        view.delegate = self

        if isFormSubmitted {
            view.hideFormAndPresentSuccessLabel()
        }

        scrollView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])

        realestateSoldStateView = view
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

    func realestateSoldStateViewDidSubmitFormWithoutContactInformation(
        _ view: RealestateSoldStateView,
        questionModels: [RealestateSoldStateQuestionModel]
    ) {
        print("""
              ✅ Did submit form without contact info, aka. user needs to log in.
              \tQuestions:
              \t\t\(questionModels)
              """)
    }

    func realestateSoldStateViewDidSelectCompanyProfileCtaButton(_ view: RealestateSoldStateView) {
        print("👉 Did select company profile CTA button.")
    }

    func realestateSoldStateView(_ view: RealestateSoldStateView, didTapCompanyProfileButtonWithIdentifier identifier: String?, url: URL) {
        print("👉 Did select company profile button with identifier '\(identifier ?? "??")'")
    }

    func realestateSoldStateViewDidToggleExpandedState(_ view: RealestateSoldStateView) {
        view.isExpanded.toggle()
    }

    func realestateSoldStateViewDidResize(_ view: RealestateSoldStateView) {
        print("📏 Did resize itself")
    }
}

// MARK: - Private extensions

private extension RealestateSoldStateModel {
    static var demoModel: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            agentProfile: .demoModel,
            questionForm: .demoModel,
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            styling: .demoStyle
        )
    }

    static var demoModelWithoutContactInfo: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            agentProfile: .demoModel,
            questionForm: .demoModel.copyWithoutContactInfo(),
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            styling: .demoStyle
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
            contactMethod: .init(
                title: "Hvordan kan vi kontakte deg?",
                emailMethod: .init(
                    identifier: "1",
                    name: "Din epost",
                    disclaimerText: "Du kan endre e-postadressen i FINN-profilen din.",
                    value: "email@provider.com"
                ),
                phoneMethod: .init(
                    identifier: "2",
                    name: "Svar meg på telefon",
                    textFieldPlaceholder: "Legg inn ditt telefonnummer"
                )
            ),
            submitDisclaimer: "Ved å trykke \"Send skjema\" samtykker du til at FINN kan sende dine opplysninger fra skjema over til ansvarlig megler for denne annonsen.",
            submitButtonTitle: "Send skjema",
            userFreeTextCharacterLimit: 40,
            userFreeTextCounterSuffix: "tegn",
            userFreeTextDisclaimer: "FINN.no forbeholder seg retten til å kontrollere og stoppe meldinger."
        )
    }
}

private extension QuestionFormViewModel {
    func copyWithoutContactInfo() -> QuestionFormViewModel {
        QuestionFormViewModel(
            questionsTitle: questionsTitle,
            questions: questions,
            contactMethod: nil,
            submitDisclaimer: submitDisclaimer,
            submitButtonTitle: submitButtonTitle,
            userFreeTextCharacterLimit: userFreeTextCharacterLimit,
            userFreeTextCounterSuffix: userFreeTextCounterSuffix,
            userFreeTextDisclaimer: userFreeTextDisclaimer
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

private extension RealestateSoldStateModel.Styling {
    static var demoStyle: RealestateSoldStateModel.Styling {
        .init(
            heading: .init(
                backgroundColor: UIColor(hex: "#0063FB"),
                logoBackgroundColor: UIColor(hex: "#FFFFFF")
            ),
            profileBox: .init(
                actionButton: .init(
                    textColor: UIColor(hex: "#464646"),
                    backgroundColor: UIColor(hex: "#FFFFFF"),
                    backgroundActiveColor: UIColor(hex: "#CCDEED"),
                    borderColor: UIColor(hex: "#FFFFFF")
                ),
                textColor: UIColor(hex: "#FFFFFF"),
                backgroundColor: UIColor(hex: "#0063FB"),
                logoBackgroundColor: UIColor(hex: "#FFFFFF")
            ),
            ctaButton: .init(
                textColor: UIColor(hex: "#FFFFFF"),
                backgroundColor: UIColor(hex: "#0063FB"),
                backgroundActiveColor: UIColor(hex: "#1E78C2"),
                borderColor: UIColor(hex: "#005AA4")
            )
        )
    }
}

private extension RealestateSoldStateFormSubmittedModel {
    static var demoModel: RealestateSoldStateFormSubmittedModel {
        .init(
            title: "Skjemaet er sendt!",
            description: "Megler svarer på din henvendelse så raskt som mulig. Forventet responstid er 1-2 dager."
        )
    }
}
