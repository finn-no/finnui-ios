import UIKit
import FinniversKit
import FinnUI

class BasicProfileDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "One contactPerson") { [weak self] in
            self?.setupDemoView(with: .demoModel)
        }
    ]

    private var basicProfileView: BasicProfileView?
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
    static var demoModel: BasicProfileViewModel {
        BasicProfileViewModel(
            companyName: "FINN eiendom",
            logoUrl: "FINN-LOGO",
            contactPersons: .contactPersons,
            buttonLinks: .buttonLinks
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
            textColor: .btnAction,
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
