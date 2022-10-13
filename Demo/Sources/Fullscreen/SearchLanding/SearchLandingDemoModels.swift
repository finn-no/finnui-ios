import Foundation
import UIKit
import FinnUI

extension Array where Element == FrontpageSearchSection {
    static func suggestions(withLocationPermission: Bool = false) -> [FrontpageSearchSection] {
        [
            withLocationPermission ? .locationPermission(.init(title: "Annonser nær meg".attributed, subtitle: nil, imageUrl: nil, uuid: UUID(), groupType:  .locationPermission, displayType: .standard)) : nil,
            .group(.generateSuggestions(title: "Torget", count: 6)),
            .group(.generateSuggestions(title: "Bolig til salgs", count: 2)),
            .group(.generateSuggestions(title: "Alle stillinger", count: 4)),
            .viewMoreResults(.init(title: "Finn flere resultater for 'hund'".attributed, subtitle: nil, imageUrl: nil, uuid: UUID(), groupType:  .showMoreResults, displayType: .standard))
        ].compactMap { $0 }
    }

    static func landingPage(withLocationPermission: Bool = false) -> [FrontpageSearchSection] {
        [
            withLocationPermission ? .locationPermission(.init(title: "Annonser nær meg".attributed, subtitle: nil, imageUrl: nil, uuid: UUID(), groupType:  .locationPermission, displayType: .standard)) : nil,
            .group(FrontpageSearchGroup(
                title: "Torget",
                items: [
                    FrontpageSearchGroupItem(title: "Torget til salgs".attributed, subtitle: "(6 073 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Torget gis bort".attributed, subtitle: "(6 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Torget ønskes kjøpt".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard)
                ],
                groupType: .regular
            )),
            .group(FrontpageSearchGroup(
                title: "Båt",
                items: [
                    FrontpageSearchGroupItem(title: "Båter til salgs".attributed, subtitle: "(6 073 treff)",imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Båtplass tilbys".attributed, subtitle: "(6 treff)",imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Båtmotorer til salgs".attributed, subtitle: "(12 treff)",imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Båter ønskes kjøpt".attributed, subtitle: "(12 treff)",imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Båter til leie".attributed, subtitle: "(12 treff)",imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard)
                ],
                groupType: .regular
            )),
            .group(FrontpageSearchGroup(
                title: "Bil",
                items: [
                    FrontpageSearchGroupItem(title: "Campingvogner".attributed, subtitle: "(6 073 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Biler i Norge".attributed, subtitle: "(6 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Bobiler".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Varebiler i Norge".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard)
                ],
                groupType: .image
            )),
            .group(FrontpageSearchGroup(
                title: "Eiendom",
                items: [
                    FrontpageSearchGroupItem(title: "Nye boliger".attributed, subtitle: "(6 073 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Fritidstomter".attributed, subtitle: "(6 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Bolig til salgs".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
                    FrontpageSearchGroupItem(title: "Bolig ønskes leid".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), groupType:  .searchResult, displayType: .standard)
                ],
                groupType: .regular
            )),
            .group(FrontpageSearchGroup(
                title: "FINN foreslår",
                items: [
                    FrontpageSearchGroupItem(
                        title: "Leilighet med sjarm og klassisk bad og kjøkken fra 60-tallet. Må ses!".attributed,
                        subtitle: nil,
                        imageUrl: .demoImageUrl,
                        uuid: UUID(),
                        groupType:  .searchResult,
                        displayType: .recommend
                    )
                ],
                groupType: .regular
            ))
        ].compactMap { $0 }
    }
}

// MARK: - Private types / extensions

private enum SuggestionStyle {
    case regular
    case highlighted
    case image

    var foregroundColor: UIColor {
        switch self {
        case .regular:
            return .textPrimary
        case .highlighted:
            return .textAction
        case .image:
            return .textPrimary
        }
    }
}

private extension FrontpageSearchGroup {
    static func generateSuggestions(title: String, count: Int) -> FrontpageSearchGroup {
        let reusableItems = [
            FrontpageSearchGroupItem(title: "sykkelvogn".attributed, subtitle: "(325 treff)", imageUrl: nil, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
            FrontpageSearchGroupItem(title: "sykkelstativ".attributed, subtitle: "(972 treff)", imageUrl: nil, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
            FrontpageSearchGroupItem(title: "hundebur".attributed, subtitle: "(972 treff)", imageUrl: nil, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
            FrontpageSearchGroupItem(title: "dører".attributed, subtitle: "(972 treff)", imageUrl: nil, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
            FrontpageSearchGroupItem(title: "playstation 5".attributed, subtitle: "(810 treff)", imageUrl: nil, uuid: UUID(), groupType:  .searchResult, displayType: .standard),
            FrontpageSearchGroupItem(title: "veldig veldig veldig lang tekst som sikkert bruker flere linjer. Hvem vet når denne ender?".attributed, subtitle: "(123 treff)", imageUrl: nil, uuid: UUID(), groupType:  .searchResult, displayType: .standard)
        ]

        var items = [FrontpageSearchGroupItem]()
        for number in (1 ... count) {
            let item = reusableItems[number % reusableItems.count]
            items.append(item)
        }

        return FrontpageSearchGroup(title: title, items: items, groupType: .regular)
    }
}

// MARK: - Private extensions

private extension String {
    static var demoImageUrl: String {
        "https://2vmcwm4fqz4pi49cl1e4a036-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/finn.no-ikon-300x300.png"
    }
}

private extension String {
    var attributed: NSAttributedString {
        NSAttributedString(string: self)
    }
}
