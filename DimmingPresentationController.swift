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
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
}