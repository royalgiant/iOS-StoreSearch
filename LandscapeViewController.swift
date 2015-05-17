//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Donald Lee on 2015-05-16.
//  Copyright (c) 2015 storesearch. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var searchResults = [SearchResult]()
    private var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.removeConstraints(view.constraints())
        view.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        pageControl.removeConstraints(pageControl.constraints())
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        scrollView.removeConstraints(scrollView.constraints())
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        
        //  Tells scroll view how big its insides are. Can only be set from code. It is a reason for why
        // scroll view doesn't scroll.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = view.bounds
        pageControl.frame = CGRect(
            x: 0,
            y: view.frame.size.height - pageControl.frame.size.height,
            width: view.frame.size.width,
            height: pageControl.frame.size.height)
            
        if firstTime {
            firstTime = false
            tileButtons(searchResults)
        }
    }
    
    deinit {
        println("deinit \(self)")
    }
    
    private func tileButtons(searchResults: [SearchResult]) {
                
        var columnsPerPage = 5
        var rowsPerPage = 3
        var itemWidth: CGFloat = 96
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 0
        var marginY: CGFloat = 20
        let scrollViewWidth = scrollView.bounds.size.width
        switch scrollViewWidth {
        case 568:
            columnsPerPage = 6
            itemWidth = 94
            marginX = 2
        case 667:
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29
        case 736:
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92
        default:
            break
        }
        
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth)/2
        let paddingVert = (itemHeight - buttonHeight)/2
                
        var row = 0
        var column = 0
        var x = marginX
        // 1
        for (index, searchResult) in enumerate(searchResults) {
            // 2
            let button = UIButton.buttonWithType(.System) as! UIButton
            button.backgroundColor = UIColor.whiteColor()
            button.setTitle("\(index)", forState: .Normal)
            // 3
            button.frame = CGRect(
                    x: x + paddingHorz,
                    y: marginY + CGFloat(row)*itemHeight + paddingVert,
                    width: buttonWidth, height: buttonHeight)
            // 4
            scrollView.addSubview(button)
            // 5
            ++row
            if row == rowsPerPage {
                row = 0
                ++column
                x += itemWidth
                if column == columnsPerPage {
                    column = 0
                    x += marginX * 2
                }
            }
        }
                
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        scrollView.contentSize = CGSize(
                width: CGFloat(numPages)*scrollViewWidth,
                height: scrollView.bounds.size.height)
        println("Number of pages: \(numPages)")
    }
}
