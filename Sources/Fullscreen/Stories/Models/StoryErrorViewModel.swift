import Foundation

public struct StoryErrorViewModel {
    public let title: String
    public let description: String

    public init(
        title: String,
        description: String
    ) {
        self.title = title
        self.description = description
    }
}
