//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import UIKit

// MARK: - View model

extension ExploreDetailViewModel {
    static let selectedCategoryDetail = ExploreDetailViewModel(
        title: "Barnerom",
        subtitle: "KOLLEKSJON",
        imageUrl: nil,
        showHeroView: false
    )

    static let collectionDetail = ExploreDetailViewModel(
        title: "Barnerom",
        subtitle: "KOLLEKSJON",
        imageUrl: nil,
        showHeroView: true
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

    static func selectedCategorySections(favorites: Set<Int>) -> [ExploreDetailSection] {
        sections(
            favorites: favorites,
            topSection: .init(title: nil, items: .selectedCategories(collections)),
            adsSectionTitle: "874 gjenstander"
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
                    imageUrl: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
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
