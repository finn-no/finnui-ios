//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

extension View {
    public func appearance<T: UIView>(customize: @escaping (T) -> Void) -> some View {
        Appearance(content: self, customize: customize)
    }
}

extension List {
    public func listSeparatorStyleNone() -> some View {
        appearance { (view: UITableView) in
            view.separatorStyle = .none
        }
    }
}

// MARK: - Private types

private struct Appearance<Content: View, UIViewType: UIView>: UIViewControllerRepresentable {
    private var content: Content
    private var customize: (UIViewType) -> Void

    init(content: Content, customize: @escaping (UIViewType) -> Void) {
        self.content = content
        self.customize = customize
    }

    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        return UIHostingController(rootView: content)
    }

    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content
        customize(UIViewType.appearance(whenContainedInInstancesOf: [UIHostingController<Content>.self]))
    }
}
