import UIKit
import FinniversKit
import FinnUI
import DemoKit

class BasicProfileDemoView: UIView {

    private var basicProfileView: BasicProfileView?
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

    private func setupDemoView(with viewModel: BasicProfileViewModel) {
        if let oldView = basicProfileView {
            oldView.removeFromSuperview()
            basicProfileView = nil
        }

        let view = BasicProfileView(
            viewModel: viewModel,
            delegate: self,
            remoteImageViewDataSource: self,
            withAutoLayout: true
        )

        scrollView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: .spacingM),
            view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: .spacingM),
            view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -.spacingM),
            view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -.spacingM)
        ])

        basicProfileView = view
    }
}

// MARK: - TweakableDemo

extension BasicProfileDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case oneContactWithMailButton
        case oneContactWithoutMailButton
        case twoContactsWithMailButton
        case twoContactsWithoutMailButton
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .oneContactWithMailButton:
            setupDemoView(with: .demoModel(contactPersonCount: 1, includeSendMail: true))
        case .oneContactWithoutMailButton:
            setupDemoView(with: .demoModel(contactPersonCount: 1, includeSendMail: false))
        case .twoContactsWithMailButton:
            setupDemoView(with: .demoModel(contactPersonCount: 2, includeSendMail: true))
        case .twoContactsWithoutMailButton:
            setupDemoView(with: .demoModel(contactPersonCount: 2, includeSendMail: false))
        }
    }
}

// MARK: - BasicProfileViewDelegate

extension BasicProfileDemoView: BasicProfileViewDelegate {
    public func basicProfileView(
        _ view: BasicProfileView,
        didSelectLinkItem linkItem: CompanyProfile.ContactPerson.LinkItem,
        contactPersonIndex: Int
    ) {
        print("👉 Did select link item for contact person at index \(contactPersonIndex). Kind: \(linkItem.kind) – Title: '\(linkItem.title)'")
    }

    public func basicProfileView(_ view: BasicProfileView, didSelectButtonWithIdentifier identifier: String?, url: URL) {
        print("ℹ️ \(String(describing: Self.self)).\(#function)")
    }
}

// MARK: - RemoteImageViewDataSource

extension BasicProfileDemoView: RemoteImageViewDataSource {
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

// MARK: - Private extensions

private extension BasicProfileViewModel {
    static func demoModel(contactPersonCount: Int, includeSendMail: Bool) -> BasicProfileViewModel {
        BasicProfileViewModel(
            companyName: "FINN eiendom",
            logoUrl: "FINN-LOGO",
            contactPersons: .contactPersons(count: contactPersonCount, includeSendMail: includeSendMail),
            buttonLinks: .buttonLinks
        )
    }
}

private extension Array {
    static var buttonLinks: [LinkButtonViewModel] {
        [
            .init(identifier: "1", title: "Hjemmeside", isExternal: true),
            .init(identifier: "2", title: "Flere annonser fra oss", isExternal: false),
            .init(identifier: "3", title: "Skal du selge bolig?", isExternal: true),
        ]
    }

    static func contactPersons(count: Int, includeSendMail: Bool) -> [CompanyProfile.ContactPerson] {
        let person = CompanyProfile.ContactPerson(
            title: "Unused for extended profile",
            name: "Navn Navnesen",
            jobTitle: "Eiendomsmegler",
            imageUrl: "https://ih1.redbubble.net/image.1257154546.3057/flat,128x128,075,t-pad,128x128,f8f8f8.jpg",
            links: .contactLinks(includeSendMail: includeSendMail)
        )

        return Array<CompanyProfile.ContactPerson>(repeating: person, count: count)
    }

    static func contactLinks(includeSendMail: Bool) -> [CompanyProfile.ContactPerson.LinkItem] {
        var links = [CompanyProfile.ContactPerson.LinkItem]()

        links.append(.phoneNumber(title: "(+47) 123 45 678"))

        if includeSendMail {
            links.append(.sendMail(title: "Send melding"))
        }

        links.append(.homepage(title: "Hjemmeside"))

        return links
    }
}

private extension LinkButtonViewModel {
    private static var demoStyle: Button.Style {
        Button.Style.flat.overrideStyle(
            textColor: .textAction,
            margins: UIEdgeInsets(vertical: .spacingS, horizontal: .zero),
            smallFont: .body
        )
    }

    init(identifier: String, title: String, isExternal: Bool) {
        self.init(
            buttonIdentifier: identifier,
            buttonTitle: title,
            linkUrl: URL(string: "https://finn.no")!,
            isExternal: isExternal,
            externalIconColor: .btnPrimary.withAlphaComponent(0.7),
            buttonStyle: Self.demoStyle,
            buttonSize: .small
        )
    }
}
