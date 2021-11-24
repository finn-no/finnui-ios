import Foundation
import UIKit
import FinnUI

class StoryDemoView: UIView {
    private lazy var storiesView: StoriesView = StoriesView(dataSource: self, delegate: self, withAutoLayout: true)
    private var favoriteIndexes = [StorySlideIndex]()
    private var imageCache = [String: UIImage]()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(storiesView)
        storiesView.fillInSuperview()
        storiesView.configure(
            with: [Self.story1, Self.story2],
            startIndex: 0,
            feedbackViewModel: Self.feedbackViewModel
        )
    }
}

extension StoryDemoView: StoriesViewDelegate {
    func storiesView(_ storiesView: StoriesView, didViewStorySlideWithIndex storySlideIndex: StorySlideIndex) {}

    func storiesView(_ storiesView: StoriesView, didSelectAction action: StoriesView.Action) {
        switch action {
        case .dismiss:
            print("DISMISS")
        case .toggleFavorite(let index, _):
            if let index = favoriteIndexes.firstIndex(where: { $0.slideIndex == index.slideIndex && $0.storyIndex == index.storyIndex }) {
                favoriteIndexes.remove(at: index)
            } else {
                favoriteIndexes.append(index)
            }
            storiesView.updateFavoriteStates()
        case .share(let index):
            print("SHARE \(index)")
        case .navigateToAd(let index):
            print("OPEN AD \(index)")
        case .navigateToSearch(let index):
            print("GO TO SEARCH \(index)")
        }
    }
}

extension StoryDemoView: StoriesViewDataSource {
    var cachesLoadedImages: Bool {
        true
    }

    func storiesView(_ storiesView: StoriesView, slidesForStoryWithIndex index: Int, completion: @escaping (([StorySlideViewModel], Int) -> Void)) {
        completion(Self.slides[index], 0)
    }

    func storiesView(_ storiesView: StoriesView, storySlideAtIndexIsFavorite index: StorySlideIndex) -> Bool {
        favoriteIndexes.contains(where: { $0.slideIndex == index.slideIndex && $0.storyIndex == index.storyIndex })
    }

    func storiesView(_ storiesView: StoriesView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        if let cachedImage = imageCache[imagePath] {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.imageCache[imagePath] = image
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }
}

// MARK: - Demo data

extension StoryDemoView {
    static var slides: [[StorySlideViewModel]] = [story1Slides, story2Slides]

    static var story1 = StoryViewModel(
        title: "Pusefinn - Torget",
        iconImageUrl: "https://static.finncdn.no/_c/static/search-assets/newfrontier/bap/torget_general.png",
        openAdButtonTitle: "Se hele annonsen"
    )

    static var story1Slides: [StorySlideViewModel] = [
        StorySlideViewModel(
            imageUrl: "https://scontent-cph2-1.xx.fbcdn.net/v/t31.18172-8/11864788_10153534768223446_3480239839577516822_o.jpg?_nc_cat=109&ccb=1-5&_nc_sid=9267fe&_nc_ohc=ipbFGlm3XSgAX-lxXZi&_nc_ht=scontent-cph2-1.xx&oh=0464cc29097580e3699015ffea21d2ac&oe=61A85031",
            title: "Regnjakke",
            detailText: "23 min siden, Trondheim",
            price: "1500 kr"
        ),
        StorySlideViewModel(
            imageUrl: nil,
            title: "Katt",
            detailText: "4 t siden, Tromsø",
            price: "20 kr"
        ),
        StorySlideViewModel(
            imageUrl: "https://scontent.fosl4-1.fna.fbcdn.net/v/t1.6435-9/246412357_10159436417758446_835789635389117397_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=e3f864&_nc_ohc=adntSSR_2_cAX9Rk-5f&_nc_ht=scontent.fosl4-1.fna&oh=f29ce65eda2652b6fd1487175a3e86c1&oe=61A51CC2",
            title: "Munch",
            detailText: "23 t siden, Oslo",
            price: "12 500 kr"
        )
    ]

    static var story2 = StoryViewModel(
        title: "Eiendommer til salgs, pris fra 3 000 000 kr, i Norge, nye i dag",
        iconImageUrl: "https://static.finncdn.no/_c/static/search-assets/newfrontier/eiendom.png",
        openAdButtonTitle: "Se hele annonsen"
    )

    static var story2Slides: [StorySlideViewModel] = [
        StorySlideViewModel(
            imageUrl: "https://images.finncdn.no/dynamic/1280w/2021/10/vertical-2/01/2/233/807/102_2001569597.jpg",
            title: "Småbruk - Tomt bestående av bolig, fjøs, garasje og uthus! Grønt og frodig.",
            detailText: "2 t siden, Askøy",
            price: "3 500 000 kr"
        ),
        StorySlideViewModel(
            imageUrl: "https://images.finncdn.no/dynamic/1280w/2021/8/vertical-2/16/5/228/598/805_47445316.jpg",
            title: "Sjelden mulighet i Ålesund",
            detailText: "23 t siden, Ålesund",
            price: "8 500 000 kr"
        )
    ]

    static var feedbackViewModel = StoryFeedbackViewModel(
        title: "Gir stories mer oversikt over nye annonser i dine lagrede søk?",
        feedbackOptions: [
            StoryFeedbackViewModel.FeedbackOption(id: 1, title: "😍 Absolutt"),
            StoryFeedbackViewModel.FeedbackOption(id: 2, title: "👌 Litt"),
            StoryFeedbackViewModel.FeedbackOption(id: 3, title: "👎 Nei")
        ]
    )
}
