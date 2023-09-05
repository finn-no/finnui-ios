import UIKit
import FinniversKit
import FinnUI
import DemoKit

class RealestateSoldStateDemoView: UIView {

    private var realestateSoldStateView: RealestateSoldStateView?
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
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
// MARK: - TweakableDemo

extension RealestateSoldStateDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case defaultExpanded
        case defaultCollapsed
        case collapsedWithPhoneNumbers
        case collapsedWithoutContactInformation
        case collapsedWithoutAgentPhoneNumber
        case collapsedWithoutAgentImage
        case collapsedWithoutAgentImageButWithPhoneNumbers
        case collapsedWithoutAgentPhoneNumberOrImage
        case formSubmitted
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .defaultExpanded:
            setupDemoView(with: .demoModel, isExpanded: true)
        case .defaultCollapsed:
            setupDemoView(with: .demoModel, isExpanded: false)
        case .collapsedWithPhoneNumbers:
            setupDemoView(with: .demoModelWithSeveralPhoneNumbers, isExpanded: false)
        case .collapsedWithoutContactInformation:
            setupDemoView(with: .demoModelWithoutContactInfo, isExpanded: false)
        case .collapsedWithoutAgentPhoneNumber:
            setupDemoView(with: .demoModelWithoutAgentPhoneNumber, isExpanded: false)
        case .collapsedWithoutAgentImage:
            setupDemoView(with: .demoModelWithoutAgentImage, isExpanded: false)
        case .collapsedWithoutAgentImageButWithPhoneNumbers:
            setupDemoView(with: .demoModelWithoutAgentImageAndSeveralPhoneNumbers, isExpanded: false)
        case .collapsedWithoutAgentPhoneNumberOrImage:
            setupDemoView(with: .demoModelWithoutPhoneNumberOrAgentImage, isExpanded: false)
        case .formSubmitted:
            setupDemoView(with: .demoModel, isExpanded: false, isFormSubmitted: true)
        }
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
              \tUser name: '\(form.userContactName ?? "[empty]")'
              \tSelected question ids:
              \t\t\(form.questions.map(\.id).joined(separator: ", "))
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

    public func realestateSoldStateView(
        _ view: RealestateSoldStateView,
        didSelectLinkItem linkItem: CompanyProfile.ContactPerson.LinkItem
    ) {
        print("📲 Did select link item. Kind: \(linkItem.kind) – Title: '\(linkItem.title)'")
    }

    func realestateSoldStateView(_ view: RealestateSoldStateView, didSelectPhoneButtonWithIndex phoneNumberIndex: Int) {
    }
}

// MARK: - Private extensions

private extension RealestateSoldStateModel {
    static var demoModel: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            contactPerson: .demoModel,
            questionForm: .demoModel,
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            style: .demoStyle
        )
    }

    static var demoModelWithSeveralPhoneNumbers: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            contactPerson: .demoModelWithSeveralPhoneNumbers,
            questionForm: .demoModel,
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            style: .demoStyle
        )
    }

    static var demoModelWithoutContactInfo: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            contactPerson: .demoModel,
            questionForm: .demoModel.copyWithoutContactInfo(),
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            style: .demoStyle
        )
    }

    static var demoModelWithoutAgentPhoneNumber: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            contactPerson: .demoModel.copyWithoutPhoneNumber(),
            questionForm: .demoModel,
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            style: .demoStyle
        )
    }

    static var demoModelWithoutAgentImage: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            contactPerson: .demoModel.copyWithoutImage(),
            questionForm: .demoModel,
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            style: .demoStyle
        )
    }

    static var demoModelWithoutAgentImageAndSeveralPhoneNumbers: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            contactPerson: .demoModelWithoutImageWithSeveralPhoneNumbers,
            questionForm: .demoModel,
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            style: .demoStyle
        )
    }

    static var demoModelWithoutPhoneNumberOrAgentImage: RealestateSoldStateModel {
        RealestateSoldStateModel(
            title: "Har du noen spørsmål rundt salget av denne boligen?",
            logoUrl: "FINN-LOGO",
            presentFormButtonTitle: "Still spørsmål til megler",
            contactPerson: .demoModel.copyWithoutPhoneNumberOrImage(),
            questionForm: .demoModel,
            companyProfile: .demoModel,
            formSubmitted: .demoModel,
            style: .demoStyle
        )
    }
}

private extension CompanyProfile.ContactPerson {
    static var demoModel: CompanyProfile.ContactPerson {
        .init(
            title: "Ansvarlig megler for dette salget",
            name: "Navn Navnesen",
            jobTitle: "Eiendomsmegler / Partner",
            imageUrl: "https://ih1.redbubble.net/image.1257154546.3057/flat,128x128,075,t-pad,128x128,f8f8f8.jpg",
            links: [.phoneNumber(title: "123 45 678")]
        )
    }

    static var demoModelWithSeveralPhoneNumbers: CompanyProfile.ContactPerson {
        .init(
            title: "Ansvarlig megler for dette salget",
            name: "Navn Navnesen",
            jobTitle: "Eiendomsmegler / Partner",
            imageUrl: "https://ih1.redbubble.net/image.1257154546.3057/flat,128x128,075,t-pad,128x128,f8f8f8.jpg",
            links: ["(+47) 123 45 678", "12 34 56 78", "+47 99 88 77 66"].map { .phoneNumber(title: $0) }
        )
    }

    static var demoModelWithoutImageWithSeveralPhoneNumbers: CompanyProfile.ContactPerson {
        .init(
            title: "Ansvarlig megler for dette salget",
            name: "Navn Navnesen",
            jobTitle: "Eiendomsmegler / Partner",
            imageUrl: nil,
            links: ["(+47) 123 45 678", "12 34 56 78", "+47 99 88 77 66"].map { .phoneNumber(title: $0) }
        )
    }

    func copyWithoutPhoneNumber() -> CompanyProfile.ContactPerson {
        .init(
            title: title,
            name: name,
            jobTitle: jobTitle,
            imageUrl: "https://ih1.redbubble.net/image.1257154546.3057/flat,128x128,075,t-pad,128x128,f8f8f8.jpg",
            links: []
        )
    }

    func copyWithoutImage() -> CompanyProfile.ContactPerson {
        .init(
            title: title,
            name: name,
            jobTitle: jobTitle,
            imageUrl: nil,
            links: [.phoneNumber(title: "123 45 678")]
        )
    }

    func copyWithoutPhoneNumberOrImage() -> CompanyProfile.ContactPerson {
        .init(
            title: title,
            name: name,
            jobTitle: jobTitle,
            imageUrl: nil,
            links: []
        )
    }
}

private extension QuestionFormViewModel {
    static var demoModel: QuestionFormViewModel {
        QuestionFormViewModel(
            questionsTitle: "Hva lurer du på?",
            questions: [
                .init(id: "1", kind: .provided, title: "Hva ble boligen solgt for?", isSelected: true),
                .init(id: "2", kind: .provided, title: "Hvor mange var det som kom på visning?", isSelected: false),
                .init(id: "3", kind: .provided, title: "Hva kan man forvente av en budrunde?", isSelected: false),
                .init(id: "4", kind: .provided, title: "Kan jeg få en verdivurdering av min bolig?", isSelected: false),
                .init(id: "5", kind: .userFreetext, title: "Annet", isSelected: true, value: "Long text\nSeveral lines\nAnother line"),
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
            userContactName: .init(title: "Navnet ditt", initialValue: "Navn Navnesen"),
            submitDisclaimer: "Ved å trykke \"Send skjema\" samtykker du til at FINN kan sende dine opplysninger fra skjema over til ansvarlig megler for denne annonsen.",
            submitButtonTitle: "Send skjema",
            userFreeTextCharacterLimit: 40,
            userFreeTextCounterSuffix: "tegn",
            userFreeTextDisclaimer: "FINN.no forbeholder seg retten til å kontrollere og stoppe meldinger."
        )
    }

    func copyWithoutContactInfo() -> QuestionFormViewModel {
        QuestionFormViewModel(
            questionsTitle: questionsTitle,
            questions: questions,
            contactMethod: nil,
            userContactName: .init(title: "Navnet ditt"),
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
                .init(identifier: "1", title: "Hjemmeside", isExternal: true),
                .init(identifier: "2", title: "Flere annonser fra oss", isExternal: false),
                .init(identifier: "3", title: "Skal du selge bolig?", isExternal: true),
            ],
            ctaButtonTitle: "Be om verdivurdering"
        )
    }
}

private extension LinkButtonViewModel {
    private static var demoStyle: Button.Style {
        Button.Style.flat.overrideStyle(margins: UIEdgeInsets(vertical: .spacingS, horizontal: .zero), smallFont: .body)
    }

    init(identifier: String, title: String, isExternal: Bool) {
        self.init(
            buttonIdentifier: identifier,
            buttonTitle: title,
            linkUrl: URL(string: "https://finn.no")!,
            isExternal: isExternal,
            buttonStyle: Self.demoStyle,
            buttonSize: .small
        )
    }
}

private extension RealestateSoldStateModel.Style {
    static var demoStyle: RealestateSoldStateModel.Style {
        .init(
            headingStyle: .init(
                backgroundColor: UIColor(hex: "#0063FB"),
                logoBackgroundColor: UIColor(hex: "#FFFFFF")
            ),
            profileStyle: .init(
                textColor: UIColor(hex: "#FFFFFF"),
                backgroundColor: UIColor(hex: "#0063FB"),
                logoBackgroundColor: UIColor(hex: "#FFFFFF"),
                actionButtonStyle: .init(
                    textColor: UIColor(hex: "#464646"),
                    backgroundColor: UIColor(hex: "#FFFFFF"),
                    backgroundActiveColor: UIColor(hex: "#CCDEED"),
                    borderColor: UIColor(hex: "#FFFFFF")
                )
            ),
            actionButtonStyle: .init(
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
