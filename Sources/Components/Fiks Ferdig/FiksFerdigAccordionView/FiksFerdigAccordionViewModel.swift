import Combine
import UIKit

public protocol FiksFerdigAccordionViewModelDelegate: AnyObject {
    func didChangeExpandedState(isExpanded: Bool)
}

public final class FiksFerdigAccordionViewModel: ObservableObject {
    public let title: String
    public let icon: UIImage
    @Published public var isExpanded: Bool {
        didSet {
            delegate?.didChangeExpandedState(isExpanded: isExpanded)
        }
    }

    public weak var delegate: FiksFerdigAccordionViewModelDelegate?

    public init(title: String, icon: UIImage, isExpanded: Bool) {
        self.title = title
        self.icon = icon
        self.isExpanded = isExpanded
    }
}
