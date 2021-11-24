import Foundation

public struct StoryFeedbackViewModel {
    let title: String
    let disclaimerText: String
    let feedbackOptions: [FeedbackOption]

    public struct FeedbackOption {
        let id: Int
        let title: String

        public init(id: Int, title: String) {
            self.id = id
            self.title = title
        }
    }

    public init(title: String, disclaimerText: String, feedbackOptions: [FeedbackOption]) {
        self.title = title
        self.disclaimerText = disclaimerText
        self.feedbackOptions = feedbackOptions
    }
}
