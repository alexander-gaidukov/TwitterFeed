//
//  ViewController.swift
//  TwitterFeed
//
//  Created by Alexandr Gaidukov on 01.02.16.
//  Copyright © 2016 Alexandr Gaidukov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tweetListView: TFTweetsCollectionView!
    
    let twitterManager = TFTwitterAccessManager.sharedInstance
    
    // MARK: - View Lifecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTwitterAccess()
    }
    
    
    // MARK: - Private ->
    
    private func setupTwitterAccess() {
        twitterManager.accessTwitterAccountsWithComplition {
            accounts, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                if accounts.count == 0 {
                    
                    let alert = UIAlertController(title: "Twitter Error", message: "Make sure you have a Twitter account set up in Settings. Also grant access to this app", preferredStyle: .Alert)
                    
                    let cancel = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
                    
                    alert.addAction(cancel)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else if accounts.count == 1 {
                    
                    self.twitterManager.account = accounts[0]
                    
                    self.refreshTwitterFeed()
                    
                } else {
                    
                    let alert = UIAlertController(title: "Select an account", message: "Please choose one of your Twitter accounts", preferredStyle: .Alert)
                    
                    for account in accounts {
                        let action = UIAlertAction(title: account.accountDescription, style: .Default) {
                            action in
                            
                            self.twitterManager.account = account
                            
                            self.refreshTwitterFeed()
                        }
                        
                        alert.addAction(action)
                    }
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func refreshTwitterFeed() {
        do {
            try twitterManager.refreshTwitterFeed{
                feed, error in
                
                dispatch_async(dispatch_get_main_queue()) {
                    if let feed = feed {
                        self.tweetListView.feed = feed
                    }
                }
                
            }
        } catch TFTwitterError.NotAuthorizedAccess {
            self.setupTwitterAccess()
        } catch _ {
            
        }
    }
}

