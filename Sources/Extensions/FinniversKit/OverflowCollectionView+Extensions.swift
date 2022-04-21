import FinniversKit

extension OverflowCollectionView where Cell.Model == String {
    func configure(withLinks links: [CompanyProfile.ContactPerson.LinkItem]) {
        let cellItems = links.map(\.title)
        configure(with: cellItems)
    }
}
