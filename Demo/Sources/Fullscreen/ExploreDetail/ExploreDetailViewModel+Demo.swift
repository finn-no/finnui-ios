//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import UIKit

extension ExploreDetailViewModel {
    static func selectedCategoryDetail(favorites: Set<Int>) -> ExploreDetailViewModel {
        viewModel(
            favorites: favorites,
            topSection: .init(title: nil, items: .selectedCategories(collections)),
            showHeroView: false,
            adsSectionTitle: "874 gjenstander"
        )
    }

    static func collectionDetail(favorites: Set<Int>) -> ExploreDetailViewModel {
        viewModel(
            favorites: favorites,
            topSection: .init(title: "Gå dypere til verks", items: .collections(collections)),
            showHeroView: true,
            adsSectionTitle: "Eller rett på sak"
        )
    }

    private static var collections = [
        ExploreCollectionViewModel(title: "Bord"),
        ExploreCollectionViewModel(title: "Seng"),
        ExploreCollectionViewModel(title: "Stellebord"),
        ExploreCollectionViewModel(title: "Stol"),
        ExploreCollectionViewModel(title: "Oppbevaring"),
        ExploreCollectionViewModel(title: "Dekorasjon")
    ]

    private static func viewModel(
        favorites: Set<Int>,
        topSection: ExploreDetailViewModel.Section,
        showHeroView: Bool,
        adsSectionTitle: String
    ) -> ExploreDetailViewModel {
        ExploreDetailViewModel(
            title: "Barnerom",
            subtitle: "KOLLEKSJON",
            imageUrl: nil,
            showHeroView: showHeroView,
            sections: [
                topSection,
                .init(title: adsSectionTitle, items: .ads([
                    ExploreAdCellViewModel(
                        title: "Hjemmekontor: skjerm, mus, tastatur+",
                        location: "Oslo",
                        price: "850 kr",
                        time: "2 timer siden",
                        aspectRatio: 1,
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
        )
    }
}
