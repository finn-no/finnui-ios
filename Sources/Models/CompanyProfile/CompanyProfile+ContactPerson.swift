import Foundation

extension CompanyProfile {
    public struct ContactPerson {
        public let title: String?
        public let name: String
        public let jobTitle: String
        public let imageUrl: String?
        public let links: [LinkItem]

        public init(title: String?, name: String, jobTitle: String, imageUrl: String?, links: [LinkItem]) {
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
        public enum Kind {
            case phoneNumber
            case homepage
            case sendMail
        }

        public let kind: Kind
        public let title: String

        public init(kind: Kind, title: String) {
            self.kind = kind
            self.title = title
        }

        // MARK: - Helper methods

        public static func phoneNumber(title: String) -> Self {
            Self.init(kind: .phoneNumber, title: title)
        }

        public static func homepage(title: String) -> Self {
            Self.init(kind: .homepage, title: title)
        }

        public static func sendMail(title: String) -> Self {
            Self.init(kind: .sendMail, title: title)
        }
    }
}
