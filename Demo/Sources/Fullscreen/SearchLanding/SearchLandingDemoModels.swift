import Foundation
import UIKit
import FinnUI

extension Array where Element == SearchLandingSection {
    static func suggestions(withLocationPermission: Bool = false) -> [SearchLandingSection] {
        [
            withLocationPermission ? .locationPermission(.init(title: "Annonser nær meg".attributed, subtitle: nil, imageUrl: nil, uuid: UUID(), type: .locationPermission)) : nil,
            .group(.generateSuggestions(title: "Torget", count: 6)),
            .group(.generateSuggestions(title: "Bolig til salgs", count: 2)),
            .group(.generateSuggestions(title: "Alle stillinger", count: 4)),
            .viewMoreResults(.init(title: "Finn flere resultater for 'hund'".attributed, subtitle: nil, imageUrl: nil, uuid: UUID(), type: .showMoreResults))
        ].compactMap { $0 }
    }

    static func landingPage(withLocationPermission: Bool = false) -> [SearchLandingSection] {
        [
            withLocationPermission ? .locationPermission(.init(title: "Annonser nær meg".attributed, subtitle: nil, imageUrl: nil, uuid: UUID(), type: .locationPermission)) : nil,
            .group(SearchLandingGroup(
                title: "Torget",
                items: [
                    SearchLandingGroupItem(title: "Torget til salgs".attributed, subtitle: "(6 073 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Torget gis bort".attributed, subtitle: "(6 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Torget ønskes kjøpt".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult)
                ],
                groupType: .regular
            )),
            .group(SearchLandingGroup(
                title: "Båt",
                items: [
                    SearchLandingGroupItem(title: "Båter til salgs".attributed, subtitle: "(6 073 treff)",imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Båtplass tilbys".attributed, subtitle: "(6 treff)",imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Båtmotorer til salgs".attributed, subtitle: "(12 treff)",imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Båter ønskes kjøpt".attributed, subtitle: "(12 treff)",imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Båter til leie".attributed, subtitle: "(12 treff)",imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult)
                ],
                groupType: .regular
            )),
            .group(SearchLandingGroup(
                title: "Bil",
                items: [
                    SearchLandingGroupItem(title: "Campingvogner".attributed, subtitle: "(6 073 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Biler i Norge".attributed, subtitle: "(6 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Bobiler".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Varebiler i Norge".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult)
                ],
                groupType: .image
            )),
            .group(SearchLandingGroup(
                title: "Eiendom",
                items: [
                    SearchLandingGroupItem(title: "Nye boliger".attributed, subtitle: "(6 073 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Fritidstomter".attributed, subtitle: "(6 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Bolig til salgs".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult),
                    SearchLandingGroupItem(title: "Bolig ønskes leid".attributed, subtitle: "(12 treff)", imageUrl: .demoImageUrl, uuid: UUID(), type: .searchResult)
                ],
                groupType: .regular
            )),
            .group(SearchLandingGroup(
                title: "FINN foreslår",
                items: [
                    SearchLandingGroupItem(
                        title: "Leilighet med sjarm og klassisk bad og kjøkken fra 60-tallet. Må ses!".attributed,
                        subtitle: nil,
                        imageUrl: .demoImageUrl,
                        uuid: UUID(),
                        type: .searchResult
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

private extension SearchLandingGroup {
    static func generateSuggestions(title: String, count: Int) -> SearchLandingGroup {
        let reusableItems = [
            SearchLandingGroupItem(title: "sykkelvogn".attributed, subtitle: "(325 treff)", imageUrl: nil, uuid: UUID(), type: .searchResult),
            SearchLandingGroupItem(title: "sykkelstativ".attributed, subtitle: "(972 treff)", imageUrl: nil, uuid: UUID(), type: .searchResult),
            SearchLandingGroupItem(title: "hundebur".attributed, subtitle: "(972 treff)", imageUrl: nil, uuid: UUID(), type: .searchResult),
            SearchLandingGroupItem(title: "dører".attributed, subtitle: "(972 treff)", imageUrl: nil, uuid: UUID(), type: .searchResult),
            SearchLandingGroupItem(title: "playstation 5".attributed, subtitle: "(810 treff)", imageUrl: nil, uuid: UUID(), type: .searchResult),
            SearchLandingGroupItem(title: "veldig veldig veldig lang tekst som sikkert bruker flere linjer. Hvem vet når denne ender?".attributed, subtitle: "(123 treff)", imageUrl: nil, uuid: UUID(), type: .searchResult)
        ]

        var items = [SearchLandingGroupItem]()
        for number in (1 ... count) {
            let item = reusableItems[number % reusableItems.count]
            items.append(item)
        }

        return SearchLandingGroup(title: title, items: items, groupType: .regular)
    }
}

private extension SearchSuggestionGroupItem {
    init(title: String, detail: String? = nil, style: SuggestionStyle = .regular, useBoldPrefix: Bool = true) {
        let sharedAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.body, .foregroundColor: style.foregroundColor]
        let attributedString = NSMutableAttributedString(string: title, attributes: sharedAttributes)

        if useBoldPrefix {
            let boldAttributes = sharedAttributes.mergeOrReplace([.font: UIFont.bodyStrong])
            attributedString.setAttributes(boldAttributes, range: NSRange(location: 0, length: 3))
        }

        self.init(title: attributedString, detail: detail)
    }
}

private extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    func mergeOrReplace(_ otherDictionary: [Key: Value]) -> [Key: Value] {
        merging(otherDictionary, uniquingKeysWith: { this, other in other })
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
