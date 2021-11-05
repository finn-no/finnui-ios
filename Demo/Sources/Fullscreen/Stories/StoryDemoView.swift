import Foundation
import UIKit
import FinnUI

class StoryDemoView: UIView {
    private lazy var storiesView: StoriesView = {
        let view = StoriesView(withAutoLayout: true)
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private var favoriteIndexes = [Int]()

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
        storiesView.configure(with: [Self.story1, Self.story2])
//        storyView.startStory()
    }
}

extension StoryDemoView: StoriesViewDelegate {
    func storyViewDidSelectShare(_ view: StoryCollectionViewCell, forIndex index: Int) {
        print("SHARE SLIDE \(index)")
    }

    func storyView(_ view: StoryCollectionViewCell, didTapFavoriteButton button: UIButton, forIndex index: Int) {
        if let indexForFavoriteItem = favoriteIndexes.firstIndex(of: index) {
            favoriteIndexes.remove(at: indexForFavoriteItem)
        } else {
            favoriteIndexes.append(index)
        }
        view.updateFavoriteButtonState()
    }

    func storyViewDidSelectSearch(_ view: StoryCollectionViewCell) {
        print("OPEN SEARCH")
    }

    func storyViewDidSelectAd(_ view: StoryCollectionViewCell) {
        print("OPEN AD")
    }

    func storyViewDidSelectNextStory(_ view: StoryCollectionViewCell) {
        print("SHOW NEXT STORY")
    }

    func storyViewDidSelectPreviousStory(_ view: StoryCollectionViewCell) {
        print("SHOW PREVIOUS STORY")
    }

    func storyViewDidFinishStory(_ view: StoryCollectionViewCell) {
        print("DISMISS STORY")
    }
}

extension StoryDemoView: StoriesViewDataSource {
    func storiesView(_ storiesView: StoriesView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func storyView(_ view: StoryCollectionViewCell, slideAtIndexIsFavorite index: Int) -> Bool {
        favoriteIndexes.contains(index)
    }
}

extension StoryDemoView {
    static var story1 = StoryViewModel(
        slides: slides,
        title: "Pusefinn - Torget",
        iconImageUrl: "https://static.finncdn.no/_c/static/search-assets/newfrontier/bap/torget_general.png",
        openAdButtonTitle: "Se hele annonsen"
    )

    static var slides: [StorySlideViewModel] = [
        StorySlideViewModel(
            imageUrl: "https://scontent-cph2-1.xx.fbcdn.net/v/t31.18172-8/11864788_10153534768223446_3480239839577516822_o.jpg?_nc_cat=109&ccb=1-5&_nc_sid=9267fe&_nc_ohc=ipbFGlm3XSgAX-lxXZi&_nc_ht=scontent-cph2-1.xx&oh=0464cc29097580e3699015ffea21d2ac&oe=61A85031",
            title: "Regnjakke",
            detailText: "23 min siden, Trondheim",
            price: "1500 kr"
        ),
        StorySlideViewModel(
            imageUrl: "https://yt3.ggpht.com/ytc/AKedOLTYio64rqGJoLKqcaHBKtVJYohlmsVSzXOcBpG6oA=s900-c-k-c0x00ffffff-no-rj",
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
        slides: slides2,
        title: "Eiendommer til salgs",
        iconImageUrl: "https://static.finncdn.no/_c/static/search-assets/newfrontier/eiendom.png",
        openAdButtonTitle: "Se hele annonsen"
    )

    static var slides2: [StorySlideViewModel] = [
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
}
