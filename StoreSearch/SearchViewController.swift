//
//  ViewController.swift
//  StoreSearch
//
//  Created by Donald Lee on 2015-05-14.
//  Copyright (c) 2015 storesearch. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let search = Search()
    
    var landscapeViewController: LandscapeViewController?
    
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        performSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Search", comment: "Split-view master button")
        searchBar.becomeFirstResponder()
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        // Register nib
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.rowHeight = 80
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            switch search.state{
                case .Results(let list):
                    let detailViewController = segue.destinationViewController as! DetailViewController
                    let indexPath = sender as! NSIndexPath
                    let searchResult = list[indexPath.row]
                    detailViewController.searchResult = searchResult
                default:
                    break
            }
        }
    }
    
    override func willTransitionToTraitCollection( newCollection: UITraitCollection,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
            // To detect iphone rotation, just look at how vertical size class changed
            switch newCollection.verticalSizeClass {
            case .Compact:
                showLandscapeViewWithCoordinator(coordinator)
            case .Regular, .Unspecified:
                hideLandscapeViewWithCoordinator(coordinator)
        }
    }
    
    func showLandscapeViewWithCoordinator(
        coordinator: UIViewControllerTransitionCoordinator) {
        // 1
        precondition(landscapeViewController == nil)
        // 2
        landscapeViewController = storyboard!.instantiateViewControllerWithIdentifier( "LandscapeViewController") as? LandscapeViewController
        if let controller = landscapeViewController {
            controller.search = search
            // 3
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            // 4
            view.addSubview(controller.view)
            addChildViewController(controller)
            
            coordinator.animateAlongsideTransition({ _ in
                controller.view.alpha = 1
                self.searchBar.resignFirstResponder()
                if self.presentedViewController != nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }, completion: { _ in
                controller.didMoveToParentViewController(self)
            })
        }
    }
    
    func hideLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeViewController {
            controller.willMoveToParentViewController(nil)
            
            coordinator.animateAlongsideTransition({ _ in
                controller.view.alpha = 0
                if self.presentedViewController != nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }, completion: { _ in
                controller.view.removeFromSuperview()
                controller.removeFromParentViewController()
                self.landscapeViewController = nil
            })
        }
    }
    
    
    
    
    
    
    
    func showNetworkError() {
        let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Error alert: title"), message: NSLocalizedString("There was an error reading from the iTunes Store. Please try again.", comment: "Error alert: message"), preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSearch()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func performSearch() {
        if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex){
            search.performSearchForText(searchBar.text, category: category, completion: {
                success in
                
                if let controller = self.landscapeViewController {
                    controller.searchResultsReceived()
                }
                
                if !success{
                    self.showNetworkError()
                }
                
                self.tableView.reloadData()
            })
            tableView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        switch search.state {
            case .NotSearchedYet:
                return 0
            case .Loading:
                return 1
            case .NoResults:
                return 1
            case .Results(let list):
                return list.count }
      
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch search.state {
            case .NotSearchedYet:
                fatalError("Should never get here")
                
            case .Loading:
                let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath:indexPath) as! UITableViewCell
    
                let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
                spinner.startAnimating()
    
                return cell
                
            case .NoResults:
                return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath) as! UITableViewCell
                
            case .Results(let list):
                let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
    
                let searchResult = list[indexPath.row]
                cell.configureForSearchResult(searchResult)
    
                return cell
        }
    }
}
extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // simply deselect the row with an animation
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowDetail", sender: indexPath)
    }
                    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        // makes sure that you can only select rows with actual search results.
        switch search.state {
            case .NotSearchedYet, .Loading, .NoResults:
                return nil
            case .Results:
                return indexPath
        }
    }
}


