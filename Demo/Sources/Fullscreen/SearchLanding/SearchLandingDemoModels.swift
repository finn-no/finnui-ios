import Foundation
import UIKit
import FinnUI

extension Array where Element == SearchSuggestionSection {
    static var suggestions: [SearchSuggestionSection] {
        [
            .group(.generateSuggestions(title: "Torget", count: 6)),
            .group(.generateSuggestions(title: "Bolig til salgs", count: 2)),
            .group(.generateSuggestions(title: "Alle stillinger", count: 4)),
            .viewMoreResults(title: "Finn flere resultater for 'hund'")
        ]
    }

    static var landingPage: [SearchSuggestionSection] {
        [
            .group(SearchSuggestionGroup(
                title: "Torget",
                items: [
                    SearchSuggestionGroupItem(title: "Torget til salgs", detail: "(6 073 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Torget gis bort", detail: "(6 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Torget ønskes kjøpt", detail: "(12 treff)", style: .regular)
                ]
            )),
            .group(SearchSuggestionGroup(
                title: "Båt",
                items: [
                    SearchSuggestionGroupItem(title: "Båter til salgs", detail: "(6 073 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Båtplass tilbys", detail: "(6 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Båtmotorer til salgs", detail: "(12 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Båter ønskes kjøpt", detail: "(12 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Båter til leie", detail: "(12 treff)", style: .regular)
                ]
            )),
            .group(SearchSuggestionGroup(
                title: "Bil",
                items: [
                    SearchSuggestionGroupItem(title: "Campingvogner", detail: "(6 073 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Biler i Norge", detail: "(6 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Bobiler", detail: "(12 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Varebiler i Norge", detail: "(12 treff)", style: .regular)
                ]
            )),
            .group(SearchSuggestionGroup(
                title: "Eiendom",
                items: [
                    SearchSuggestionGroupItem(title: "Nye boliger", detail: "(6 073 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Fritidstomter", detail: "(6 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Bolig til salgs", detail: "(12 treff)", style: .regular),
                    SearchSuggestionGroupItem(title: "Bolig ønskes leid", detail: "(12 treff)", style: .regular)
                ]
            )),
            .group(SearchSuggestionGroup(
                title: "FINN foreslår",
                items: [
                    SearchSuggestionGroupItem(title: "Leilighet med sjarm og klassisk bad og kjøkken fra 60-tallet. Må ses!", detail: nil, style: .regular)
                ]
            )),
        ]
    }
}

extension SearchSuggestionGroup {
    static func generateSuggestions(title: String, count: Int) -> SearchSuggestionGroup {
        let reusableItems = [
            SearchSuggestionGroupItem(title: "sykkelvogn", detail: "(325 treff)"),
            SearchSuggestionGroupItem(title: "sykkelstativ", detail: "(972 treff)"),
            SearchSuggestionGroupItem(title: "hundebur", detail: "(972 treff)"),
            SearchSuggestionGroupItem(title: "dører", detail: "(972 treff)", style: .highlighted),
            SearchSuggestionGroupItem(title: "playstation 5", detail: "(810 treff)", style: .highlighted),
            SearchSuggestionGroupItem(title: "veldig veldig veldig lang tekst som sikkert bruker flere linjer. Hvem vet når denne ender?", detail: "(123 treff)")
        ]

        var items = [SearchSuggestionGroupItem]()
        for number in (1 ... count) {
            let item = reusableItems[number % reusableItems.count]
            items.append(item)
        }

        return SearchSuggestionGroup(title: title, items: items)
    }
}
