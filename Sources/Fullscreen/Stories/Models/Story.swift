import Foundation
import UIKit

class Story {
    let viewModel: StoryViewModel
    var slideIndex: Int = 0

    init(viewModel: StoryViewModel) {
        self.viewModel = viewModel
    }
}
