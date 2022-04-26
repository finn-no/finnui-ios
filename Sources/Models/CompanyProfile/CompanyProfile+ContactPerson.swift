import Foundation

extension CompanyProfile {
    public struct ContactPerson {
        public let title: String
        public let name: String
        public let jobTitle: String
        public let imageUrl: String?
        public let phoneNumbers: [String]
        public let homepageUrl: String?

        public init(
            title: String,
            name: String,
            jobTitle: String,
            imageUrl: String?,
            phoneNumbers: [String],
            homepageUrl: String? = nil
        ) {
            self.title = title
            self.name = name
            self.jobTitle = jobTitle
            self.imageUrl = imageUrl
            self.phoneNumbers = phoneNumbers
            self.homepageUrl = homepageUrl
        }
    }
}
