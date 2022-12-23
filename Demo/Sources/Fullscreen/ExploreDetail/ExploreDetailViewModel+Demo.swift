//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import UIKit
import FinniversKit

// MARK: - View model

extension ExploreDetailViewModel {
    static let collectionDetail = ExploreDetailViewModel(
        title: "Barnerom",
        subtitle: "KOLLEKSJON",
        imageUrl: nil
    )
}

// MARK: - Sections

extension ExploreDetailSection {
    static func collectionDetailSections(favorites: Set<Int>) -> [ExploreDetailSection] {
        sections(
            favorites: favorites,
            topSection: .init(title: "Gå dypere til verks", items: .collections(collections)),
            adsSectionTitle: "Eller rett på sak"
        )
    }

    private static func sections(
        favorites: Set<Int>,
        topSection: ExploreDetailSection,
        adsSectionTitle: String
    ) -> [ExploreDetailSection] {
        [
            topSection,
            .init(title: adsSectionTitle, items: .ads([
                ExploreAdCellViewModel(
                    title: "Hjemmekontor: skjerm, mus, tastatur+",
                    location: "Oslo",
                    price: "850 kr",
                    time: "2 timer siden",
                    aspectRatio: 1,
                    badgeViewModel: BadgeViewModel(title: "Fiks ferdig", icon: UIImage(named: .bapShippable)),
                    isFavorite: favorites.contains(0)
                ),
                ExploreAdCellViewModel(
                    title: "Ståbord for hjemmekontor",
                    location: "Oslo",
                    price: "4999 kr",
                    time: "2 timer siden",
                    aspectRatio: 1.33,
                    isFavorite: favorites.contains(1)
                ),
                ExploreAdCellViewModel(
                    title: "Aarsland hyller til kontor/hjemmekontor",
                    location: "Oslo",
                    price: "500 kr",
                    time: "2 timer siden",
                    aspectRatio: 0.74,
                    isFavorite: favorites.contains(2)
                ),
                ExploreAdCellViewModel(
                    title: "Pent brukt Microsoft Surface laptop",
                    location: "Oslo",
                    price: "4000 kr",
                    time: "2 timer siden",
                    aspectRatio: 1,
                    isFavorite: favorites.contains(3)
                )
            ]))
        ]
    }

    private static var collections = [
        ExploreCollectionViewModel(title: "Bord"),
        ExploreCollectionViewModel(title: "Seng"),
        ExploreCollectionViewModel(title: "Stellebord"),
        ExploreCollectionViewModel(title: "Stol"),
        ExploreCollectionViewModel(title: "Oppbevaring"),
        ExploreCollectionViewModel(title: "Dekorasjon")
    ]
}
