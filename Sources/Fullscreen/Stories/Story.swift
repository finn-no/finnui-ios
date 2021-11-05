import Foundation
import UIKit

class Story {
    let viewModel: StoryViewModel
    var slideIndex: Int = 0
    var images = [String: UIImage?]()

    init(viewModel: StoryViewModel) {
        self.viewModel = viewModel
    }
}
