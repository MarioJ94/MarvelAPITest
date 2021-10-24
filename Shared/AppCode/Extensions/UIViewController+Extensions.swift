//
//  UIViewController+Extensions.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation
import UIKit

extension UIViewController {
    func add(_ child: UINavigationController, inContainerView containerView: UIView, withAutolayoutMatch: Bool = true) {
        addChild(child)
        child.willMove(toParent: self)
        containerView.addSubview(child.view)
        if withAutolayoutMatch {
            // This is different since using UIUtil.autolayoutMatch causes the child view to disappear when dismissing the settings view
            child.view.translatesAutoresizingMaskIntoConstraints = true
            child.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            child.view.frame = containerView.bounds
        }
        child.didMove(toParent: self)
    }
}
