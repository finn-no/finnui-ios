import Combine

public protocol SuggestShippingService: AnyObject {
    func suggestShipping(forAdId adId: String) async
}

@MainActor
public class SuggestShippingViewModel: ObservableObject {
    @Published var state: State

    private(set) var title: String
    private(set) var message: String
    private(set) var buttonTitle: String

    private let adId: String
    private weak var service: SuggestShippingService?

    public init(
        title: String,
        message: String,
        buttonTitle: String,
        adId: String,
        suggestShippingService: SuggestShippingService
    ) {
        self.adId = adId
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.state = .suggestShipping
        self.service = suggestShippingService
    }

    public func suggestShipping() {
        state = .processing
        Task {
            await service?.suggestShipping(forAdId: adId)
        }
    }
}

public extension SuggestShippingViewModel {
    enum State {
        case suggestShipping
        case processing
    }
}
