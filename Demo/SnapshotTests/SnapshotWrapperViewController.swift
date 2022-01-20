import UIKit

class SnapshotWrapperViewController: UIViewController {
    let demoViewController: UIViewController

    init(demoViewController: UIViewController) {
        self.demoViewController = demoViewController
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)

        let lightModeTraitCollection = UITraitCollection(userInterfaceStyle: .light)
        setOverrideTraitCollection(lightModeTraitCollection, forChild: viewController)
    }
}
