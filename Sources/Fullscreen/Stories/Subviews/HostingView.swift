import SwiftUI

public final class HostingView<Content: View>: UIView, HostingViewProtocol {
    var contentView: UIView { self }
    private let hostingController = UIHostingController<Content?>(rootView: nil)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        hostingController.view.backgroundColor = .clear
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public func host(_ rootView: Content, parent: UIViewController) {
        host(rootView, in: hostingController, parent: parent)
    }
}

// MARK: - Helper protocol

protocol HostingViewProtocol {
    var contentView: UIView { get }

    func host<Content: View>(
        _ rootView: Content,
        in hostingController: UIHostingController<Content?>,
        parent: UIViewController
    )
}

extension HostingViewProtocol where Self: UIView {
    func host<Content: View>(
        _ rootView: Content,
        in hostingController: UIHostingController<Content?>,
        parent: UIViewController
    ) {
        hostingController.rootView = rootView
        hostingController.view.invalidateIntrinsicContentSize()

        let requiresControllerMove = hostingController.parent != parent

        if requiresControllerMove {
            parent.addChild(hostingController)
        }

        if !contentView.subviews.contains(hostingController.view) {
            contentView.addSubview(hostingController.view)

            hostingController.view.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }

        if requiresControllerMove {
            hostingController.didMove(toParent: parent)
        }
    }
}
