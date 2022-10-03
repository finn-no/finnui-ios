//
//  WishListButtonDemoView.swift
//  Demo
//
//  Created by Alexander Wiig Sørensen on 29/09/2022.
//  Copyright © 2022 FINN.no AS. All rights reserved.
//

import Foundation
import UIKit
import FinnUI

final class WishListButtonDemoView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private lazy var wishListButton = WishListButton(withAutoLayout: true)


    // MARK: - Setup

    private func setup() {
        addSubview(wishListButton)
        // tweakingOptions.first?.action?()

        NSLayoutConstraint.activate([
            wishListButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            wishListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            wishListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
    
    
}
