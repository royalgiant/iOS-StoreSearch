//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Donald Lee on 2015-05-15.
//  Copyright (c) 2015 storesearch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController:presented, presentingViewController: presenting)
    }
}