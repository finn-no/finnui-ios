import SwiftUI

public final class HostingCollectionViewCell<Content: View>: UICollectionViewCell, HostingViewProtocol {
    private var hostingController = UIHostingController<Content?>(rootView: nil)

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
        hostingController.remove()
        hostingController = UIHostingController(rootView: rootView)
        host(rootView, in: hostingController, parent: parent)
    }
}
