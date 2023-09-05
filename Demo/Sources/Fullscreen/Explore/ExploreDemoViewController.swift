import Foundation
import UIKit
import DemoKit

class ExploreDemoViewController: UIViewController, Demoable {

    var presentation: DemoablePresentation { .navigationController }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Setup

    private func setup() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.bodyStrong,
            .foregroundColor: UIColor.textPrimary
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont(name: UIFont.title1.fontName, size: 28.0)!,
            .foregroundColor: UIColor.textPrimary
        ]

        navigationItem.title = "Torget"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.standardAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: .filter),
            style: .plain,
            target: nil,
            action: nil
        )

        let searchController = UISearchController(searchResultsController: nil)
        searchController.showsSearchResultsController = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Søk på Torget"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        let exploreView = ExploreDemoView(withAutoLayout: true)
        view.addSubview(exploreView)
        exploreView.fillInSuperview()
    }
}
