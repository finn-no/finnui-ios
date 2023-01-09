import Foundation

public struct StoryErrorViewModel {
    public let title: String
    public let description: String
    public let icon: UIImage

    public init(
        title: String,
        description: String,
        icon: UIImage
    ) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}
