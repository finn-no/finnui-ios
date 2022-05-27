import Combine

public protocol SuggestShippingService {
    func suggestShipping() async -> SuggestShippingViewModel.SuggestShippingResult
}

@MainActor
public class SuggestShippingViewModel: ObservableObject {
    @Published var state: State

    private let service: SuggestShippingService
    private let onSuccessfulSuggesting: () -> Void

    public init(
        suggestViewModel: SuggestViewModel,
        suggestShippingService: SuggestShippingService,
        onSuccessfulSuggesting: @escaping () -> Void
    ) {
        self.state = .suggestShipping(suggestViewModel)
        self.service = suggestShippingService
        self.onSuccessfulSuggesting = onSuccessfulSuggesting
    }

    public func suggestShipping() {
        state = .processing
        Task {
            let result = await service.suggestShipping()
            switch result {
            case .success:
                onSuccessfulSuggesting()

            case .failure(let errorViewModel):
                state = .error(errorViewModel)
            }
        }
    }
}

public extension SuggestShippingViewModel {
    enum SuggestShippingResult {
        case success
        case failure(ErrorViewModel)
    }
}

public extension SuggestShippingViewModel {
    enum State {
        case suggestShipping(SuggestViewModel)
        case processing
        case error(ErrorViewModel)
    }
}

public extension SuggestShippingViewModel {
    struct SuggestViewModel {
        let title: String
        let message: String
        let buttonTitle: String

        public init(title: String, message: String, buttonTitle: String) {
            self.title = title
            self.message = message
            self.buttonTitle = buttonTitle
        }
    }

    struct ErrorViewModel {
        let title: String
        let message: String
//        let infoURL: URL?

        public init(title: String, message: String) {
            self.title = title
            self.message = message
//            self.infoURL = infoURL
        }
    }
}
