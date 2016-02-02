//
//  TFTweetCollectionViewCell.swift
//  TwitterFeed
//
//  Created by Alexandr Gaidukov on 02.02.16.
//  Copyright © 2016 Alexandr Gaidukov. All rights reserved.
//

import UIKit

class TFTweetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var tweet: TFTweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 1.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicator.stopAnimating()
    }
    
    func prepareForDisplay() {
        
        if let photo = tweet.photo {
            
            indicator.startAnimating()
            
            imageView.kf_setImageWithURL(NSURL(string: photo.imageURL)!, placeholderImage: nil, optionsInfo: nil, completionHandler: {
                image, error, cacheType, imageURL  in
                
                self.indicator.stopAnimating()
            })
        } else {
            imageView.image = nil
        }
    }
    
    func setup(tweet: TFTweet) {
        
        self.tweet = tweet
        
        if let photo = tweet.photo {
            imageViewHeightConstraint.constant = (frame.size.width - 16.0) * CGFloat(photo.imageHeight) / CGFloat(photo.imageWidth)
        } else {
            imageViewHeightConstraint.constant = 0.0
        }
        
        userNameLabel.preferredMaxLayoutWidth = frame.size.width - 16.0
        tweetTextLabel.preferredMaxLayoutWidth = frame.size.width - 16.0
        userNameLabel.text = tweet.userName
        tweetTextLabel.text = tweet.text
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateLabel.text = formatter.stringFromDate(tweet.postedAt)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func heightForTweet(tweet: TFTweet) -> CGFloat {
        setup(tweet)
        
        return contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    }
}
