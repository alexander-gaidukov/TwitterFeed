import Foundation
import Accounts
import Social

enum TFTwitterError: ErrorType {
    case NotAuthorizedAccess
}

class TFTwitterAccessManager {
    
    let selectedTwitterAccount = "SelectedTwitterAccount"
    
    static let sharedInstance: TFTwitterAccessManager = TFTwitterAccessManager()
    
    var account: ACAccount! {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(account.identifier, forKey: selectedTwitterAccount)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    let accountStore: ACAccountStore = ACAccountStore()
    
    func accessTwitterAccountsWithComplition(complition: (accounts: [ACAccount], error: NSError!) -> Void) {
        
        if account != nil { // Already signed in
            complition(accounts: [account], error: nil)
            return
        }
        
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) {
            granted, error in
            
            if granted {
                
                let accounts = self.accountStore.accountsWithAccountType(twitterAccountType)
                
                if let twitterAccounts = accounts as? [ACAccount] {
                    if twitterAccounts.count > 1 {
                        if let identifier = NSUserDefaults.standardUserDefaults().objectForKey(self.selectedTwitterAccount) as? String, let account = self.accountStore.accountWithIdentifier(identifier) { // Remember if user already choose one

                            complition(accounts: [account], error: nil)
                            
                        } else {
                            complition(accounts: twitterAccounts, error: nil)
                        }
                    } else {
                        complition(accounts: twitterAccounts, error: nil)
                    }
                } else {
                    complition(accounts: [], error: nil)
                }
                
            } else {
                complition(accounts: [], error: error)
            }
            
        }
    }
    
    func refreshTwitterFeed(complition:(feed: [TFTweet]!, error: NSError!) -> Void) throws {
        
        guard let account = account else {
            throw TFTwitterError.NotAuthorizedAccess
        }
        
        let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        
        let params = ["count": "50", "screen_name": account.accountDescription]
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: params)
        
        request.account = account
        
        request.performRequestWithHandler {
            data, response, error in
            
            if let error = error {
                complition(feed: nil, error: error)
            } else {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    
                    var result = [TFTweet]()
                    
                    if let items = json as? NSArray {
                        for item in items {
                            if let feedParams = item as? NSDictionary {
                                result.append(TFTweet(params: feedParams))
                            }
                        }
                    }
                    
                    complition(feed: result, error: nil)
                } catch _ {
                    complition(feed: nil, error: nil)
                }
            }
        }
    }
}