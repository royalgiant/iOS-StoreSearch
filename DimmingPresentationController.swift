//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Donald Lee on 2015-05-16.
//  Copyright (c) 2015 storesearch. All rights reserved.
//

import Foundation

import UIKit
class DimmingPresentationController: UIPresentationController {
    
    lazy var dimmingView = GradientView(frame: CGRect.zeroRect)
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, atIndex: 0)
    }
}