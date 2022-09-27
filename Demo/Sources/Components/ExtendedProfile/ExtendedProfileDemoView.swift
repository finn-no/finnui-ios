import UIKit
import FinniversKit
import FinnUI

class ExtendedProfileDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Is expandable: true, is expanded: true") { [weak self] in
            self?.setupDemoView(with: .demoModel, isExpandable: true, isExpanded: true)
        },
        .init(title: "Is expandable: true, is expanded: false") { [weak self] in
            self?.setupDemoView(with: .demoModel, isExpandable: true, isExpanded: false)
        },
        .init(title: "Is expandable: false, is expanded: true") { [weak self] in
            self?.setupDemoView(with: .demoModel, isExpandable: false, isExpanded: true)
        },
        .init(title: "Is expandable: false, is expanded: false") { [weak self] in
            self?.setupDemoView(with: .demoModel, isExpandable: false, isExpanded: false)
        },
    ]

    private var extendedProfileView: ExtendedProfileView?
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

    private func setupDemoView(with viewModel: ExtendedProfileViewModel, isExpandable: Bool, isExpanded: Bool) {
        if let oldView = extendedProfileView {
            oldView.removeFromSuperview()
            extendedProfileView = nil
        }

        let view = ExtendedProfileView(
            viewModel: viewModel,
            isExpanded: isExpanded,
            isExpandable: isExpandable,
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

        extendedProfileView = view
    }
}

// MARK: - ExtendedProfileViewDelegate

extension ExtendedProfileDemoView: ExtendedProfileViewDelegate {
    public func extendedProfileView(
        _ view: ExtendedProfileView,
        didSelectLinkItem linkItem: CompanyProfile.ContactPerson.LinkItem,
        contactPersonIndex: Int
    ) {
        print("👉 Did select link item for contact person at index \(contactPersonIndex). Kind: \(linkItem.kind) – Title: '\(linkItem.title)'")
    }

    public func extendedProfileView(_ view: ExtendedProfileView, didSelectButtonWithIdentifier identifier: String?, url: URL) {
        print("ℹ️ \(String(describing: Self.self)).\(#function)")
    }

    public func extendedProfileViewDidSelectActionButton(_ view: ExtendedProfileView) {
        print("ℹ️ \(String(describing: Self.self)).\(#function)")
    }

    public func extendedProfileViewDidToggleExpandedState(_ view: ExtendedProfileView) {
        view.isExpanded.toggle()
    }
}

// MARK: - RemoteImageViewDataSource

extension ExtendedProfileDemoView: RemoteImageViewDataSource {
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

private extension ExtendedProfileViewModel {
    static var demoModel: ExtendedProfileViewModel {
        ExtendedProfileViewModel(
            companyName: "FINN eiendom",
            slogan: "Vi er best – ingen protest",
            logoUrl: "FINN-LOGO",
            contactPersons: .contactPersons,
            style: .demoStyle,
            buttonLinks: .buttonLinks,
            actionButtonTitle: "Les mer her"
        )
    }
}

private extension Array {
    static var contactPersons: [CompanyProfile.ContactPerson] {
        let person = CompanyProfile.ContactPerson(
                title: "Unused for extended profile",
                name: "Navn Navnesen",
                jobTitle: "Eiendomsmegler",
                imageUrl: "https://ih1.redbubble.net/image.1257154546.3057/flat,128x128,075,t-pad,128x128,f8f8f8.jpg",
                links: .contactLinks
            )

        return [person, person]
    }

    static var buttonLinks: [LinkButtonViewModel] {
        [
            .init(identifier: "1", title: "Hjemmeside", isExternal: true),
            .init(identifier: "2", title: "Flere annonser fra oss", isExternal: false),
            .init(identifier: "3", title: "Skal du selge bolig?", isExternal: true),
        ]
    }

    static var contactLinks: [CompanyProfile.ContactPerson.LinkItem] {
        [
            .phoneNumber(title: "(+47) 123 45 678"),
            .sendMail(title: "Send melding"),
            .homepage(title: "Hjemmeside"),
        ]
    }
}

private extension LinkButtonViewModel {
    private static var demoStyle: Button.Style {
        Button.Style.flat.overrideStyle(
            textColor: .white,
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
            externalIconColor: .white.withAlphaComponent(0.7),
            buttonStyle: Self.demoStyle,
            buttonSize: .small
        )
    }
}

private extension CompanyProfile.ProfileStyle {
    static var demoStyle: CompanyProfile.ProfileStyle {
        .init(
            textColor: UIColor(hex: "#FFFFFF"),
            backgroundColor: UIColor(hex: "#0063FB"),
            logoBackgroundColor: UIColor(hex: "#FFFFFF"),
            actionButtonStyle: .init(
                textColor: UIColor(hex: "#464646"),
                backgroundColor: UIColor(hex: "#FFFFFF"),
                backgroundActiveColor: UIColor(hex: "#CCDEED"),
                borderColor: UIColor(hex: "#FFFFFF")
            )
        )
    }
}
