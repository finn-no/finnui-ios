import UIKit

class NavigationController: UINavigationController {
    // MARK: - Internal properties

    var hairlineIsHidden: Bool = false {
        didSet {
            hairlineView?.isHidden = hairlineIsHidden
            if hairlineIsHidden {
                navigationBar.shadowImage = UIImage()
            }
        }
    }

    // MARK: - Private properties

    private var hairlineView: UIView?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        setBottomBorderColor(navigationBar: navigationBar, color: .textDisabled, height: 0.5)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .bgPrimary
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    // MARK: - Private methods

    private func setBottomBorderColor(navigationBar: UINavigationBar, color: UIColor, height: CGFloat) {
        if hairlineView == nil {
            let bottomBorderRect = CGRect(x: 0, y: navigationBar.frame.height, width: navigationBar.frame.width, height: height)
            let view = UIView(frame: bottomBorderRect)
            navigationBar.addSubview(view)
            hairlineView = view
        }

        hairlineView?.backgroundColor = color
    }
}
