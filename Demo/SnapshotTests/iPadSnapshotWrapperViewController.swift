import UIKit

class iPadSnapshotWrapperViewController: UIViewController {
    func setDemoViewController(_ viewController: UIViewController) {
        view.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)

        let regularWidthTraitCollection = UITraitCollection(horizontalSizeClass: .regular)
        setOverrideTraitCollection(regularWidthTraitCollection, forChild: viewController)
    }
}
