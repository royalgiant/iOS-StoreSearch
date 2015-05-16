//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Donald Lee on 2015-05-15.
//  Copyright (c) 2015 storesearch. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImageWithURL(url: NSURL) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        // 1
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: { [weak self] url, response, error in
            // 2
            if error == nil && url != nil {
                // 3
                if let data = NSData(contentsOfURL: url) {
                    if let image = UIImage(data: data){
                        // 4
                        dispatch_async(dispatch_get_main_queue()){
                            if let strongSelf = self {
                                strongSelf.image = image
                            }
                        }
                    }
                }
            }
        })
        // 5 
        downloadTask.resume()
        return downloadTask
    }

}
