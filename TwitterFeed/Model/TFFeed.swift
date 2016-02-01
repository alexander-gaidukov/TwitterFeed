import Foundation


class TFFeed {
    
    var userName: String!
    
    var postedAt: NSDate!
    
    var imageURL: String?
    
    var text: String!
    
    init(params: NSDictionary) {
        if let text = params["text"] as? String {
            self.text = text
        }
        
        if let postedAt = params["created_at"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZ yyyy"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            
            self.postedAt = dateFormatter.dateFromString(postedAt)
        }
        
        if let user = params["user"] as? NSDictionary {
            if let userName = user["name"] as? String {
                self.userName = userName
            }
        }
        
        if let entities = params["entities"] as? NSDictionary {
            if let medias = entities["media"] as? NSArray {
                for media in medias {
                    if let mediaParams = media as? NSDictionary {
                        if mediaParams["type"] as? String == "photo" { // We show only images
                            if let imageURL = mediaParams["media_url"] as? String {
                                self.imageURL = imageURL
                            }
                        }
                    }
                }
            }
        }
    }
}