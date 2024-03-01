//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit
import DemoKit

class ChatAvailabilityDemoView: UIView {

    private lazy var chatAvailabilityView = ChatAvailabilityView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        configure(forTweakAt: 0)
        addSubview(chatAvailabilityView)

        NSLayoutConstraint.activate([
            chatAvailabilityView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            chatAvailabilityView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            chatAvailabilityView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - TweakableDemo

extension ChatAvailabilityDemoView: TweakableDemo {
    enum ChatStatus: String, CaseIterable, TweakingOption {
        case online
        case offline
        case loading
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { ChatStatus.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        ChatStatus.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        let chatStatus = ChatStatus.allCases[index]
        chatAvailabilityView.configure(with: ChatAvailabilityData(chatStatus: chatStatus))
    }
}

// MARK: - Private types


private struct ChatAvailabilityData: ChatAvailabilityViewModel {
    let title = "Live videovisning av bilen"
    let text = "Med live videovisning kan du se bilen på video mens du snakker med forhandleren."
    let actionButtonTitle: String
    let isActionButtonEnabled: Bool
    let isLoading: Bool
    let statusTitle: String?
    let bookTimeTitle: String?
    let bookTimeButtonTitle: String?

    init(chatStatus: ChatAvailabilityDemoView.ChatStatus) {
        switch chatStatus {
        case .online:
            self.init(
                actionButtonTitle: "Be om videovisning",
                isActionButtonEnabled: true,
                isLoading: false,
                statusTitle: "Tilgjengelig nå",
                bookTimeTitle: "Passer det ikke akkurat nå?",
                bookTimeButtonTitle: "Foreslå tid for videovisning"
            )
        case .offline:
            self.init(
                actionButtonTitle: "Foreslå tid for videovisning",
                isActionButtonEnabled: true,
                isLoading: false,
                statusTitle: nil,
                bookTimeTitle: nil,
                bookTimeButtonTitle: nil
            )
        case .loading:
            self.init(
                actionButtonTitle: "Be om videovisning",
                isActionButtonEnabled: false,
                isLoading: true,
                statusTitle: "Laster tilgjengelighet",
                bookTimeTitle: nil,
                bookTimeButtonTitle: nil
            )
        }
    }

    init(
        actionButtonTitle: String,
        isActionButtonEnabled: Bool,
        isLoading: Bool,
        statusTitle: String?,
        bookTimeTitle: String?,
        bookTimeButtonTitle: String?
    ) {
        self.actionButtonTitle = actionButtonTitle
        self.isActionButtonEnabled = isActionButtonEnabled
        self.isLoading = isLoading
        self.statusTitle = statusTitle
        self.bookTimeTitle = bookTimeTitle
        self.bookTimeButtonTitle = bookTimeButtonTitle
    }
}
