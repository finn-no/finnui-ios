import UIKit

public protocol FiksFerdigServiceInfoViewModelDelegate: AnyObject {
    func fiksFerdigServiceInfoViewModelDidRequestReadMore(at url: URL)
}

public final class FiksFerdigServiceInfoViewModel {
    public let message: String
    public let timeLineItems: [TimeLineItem]
    public let readMoreTitle: String
    public let readMoreURL: URL
    public let headerViewModel: FiksFerdigInfoBaseViewModel
    public weak var delegate: FiksFerdigServiceInfoViewModelDelegate?

    public init(
        headerTitle: String,
        message: String,
        timeLineItems: [TimeLineItem],
        readMoreTitle: String,
        readMoreURL: URL,
        isExpanded: Bool = false
    ) {
        self.message = message
        self.timeLineItems = timeLineItems
        self.readMoreTitle = readMoreTitle
        self.readMoreURL = readMoreURL
        self.headerViewModel = FiksFerdigInfoBaseViewModel(
            title: headerTitle,
            icon: UIImage(named: .tjtTorgetShipping)
        )
    }

    func displayHelp() {
        delegate?.fiksFerdigServiceInfoViewModelDidRequestReadMore(at: readMoreURL)
    }
}
