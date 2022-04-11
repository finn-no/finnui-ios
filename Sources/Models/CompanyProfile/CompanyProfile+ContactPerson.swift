import Foundation

extension CompanyProfile {
    public struct ContactPerson {
        public let title: String
        public let name: String
        public let jobTitle: String
        public let imageUrl: String?
        public let links: [LinkItem]

        public init(title: String, name: String, jobTitle: String, imageUrl: String?, links: [LinkItem]) {
            self.title = title
            self.name = name
            self.jobTitle = jobTitle
            self.imageUrl = imageUrl
            self.links = links
        }
    }
}

extension CompanyProfile.ContactPerson {
    public struct LinkItem {
        public let kind: Kind
        public let value: String

        public init(kind: Kind, value: String) {
            self.kind = kind
            self.value = value
        }

        public enum Kind {
            case phoneNumber
            case homepage
            case sendMail
        }
    }
}
