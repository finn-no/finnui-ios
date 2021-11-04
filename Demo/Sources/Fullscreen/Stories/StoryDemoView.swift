import Foundation
import UIKit
import FinnUI

class StoryDemoView: UIView {
    private lazy var storyView: StoryView = {
        let view = StoryView(withAutoLayout: true)
        view.delegate = self
        view.dataSource = self
        return view
    }()

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
        addSubview(storyView)
        storyView.fillInSuperview()
        storyView.dataSource = self
        storyView.configure(with: Self.viewModel)
        storyView.startStory()
    }
}

extension StoryDemoView: StoryViewDelegate {
    func storyViewDidSelectSearch(_ view: StoryView) {
        print("OPEN SEARCH")
    }

    func storyViewDidSelectAd(_ view: StoryView) {
        print("OPEN AD")
    }

    func storyViewDidSelectNextStory(_ view: StoryView) {
        print("SHOW NEXT STORY")
    }

    func storyViewDidSelectPreviousStory(_ view: StoryView) {
        print("SHOW PREVIOUS STORY")
    }

    func storyViewDidFinishStory(_ view: StoryView) {
        print("DISMISS STORY")
    }
}

extension StoryDemoView: StoryViewDataSource {
    func storyView(_ view: StoryView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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
}

extension StoryDemoView {
    static var viewModel = StoryViewModel(
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
}
