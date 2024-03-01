import Foundation

public struct StoryFeedbackViewModel {
    let title: String
    let disclaimerText: String
    let feedbackOptions: [String]
    let feedbackGivenText: String

    public init(
        title: String,
        disclaimerText: String,
        feedbackOptions: [String],
        feedbackGivenText: String
    ) {
        self.title = title
        self.disclaimerText = disclaimerText
        self.feedbackOptions = feedbackOptions
        self.feedbackGivenText = feedbackGivenText
    }
}
