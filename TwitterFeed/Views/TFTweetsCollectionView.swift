//
//  TFTweetsCollectionView.swift
//  TwitterFeed
//
//  Created by Alexandr Gaidukov on 02.02.16.
//  Copyright © 2016 Alexandr Gaidukov. All rights reserved.
//

import UIKit

enum TFTweetsCollectionViewStyle: Int {
    case LIST = 0
    case TABLE = 1
}

class TFTweetsCollectionView: UICollectionView {
    
    let cellIdentifier = "TweetCellIdentifier"
    
    var heightCell: TFTweetCollectionViewCell!
    
    var style: TFTweetsCollectionViewStyle = .LIST {
        didSet {
            reloadData()
        }
    }
    
    var numberOfColumns: Int {
        return style == .LIST ? 1 : 2
    }
    
    var feed: [TFTweet] = [TFTweet]() {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        
        setupCell()
    }
    
    private func setupCell() {
        registerNib(UINib(nibName: "TFTweetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        heightCell = NSBundle.mainBundle().loadNibNamed("TFTweetCollectionViewCell", owner: nil, options: nil).first as! TFTweetCollectionViewCell
    }
}

extension TFTweetsCollectionView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! TFTweetCollectionViewCell
        
        cell.setup(feed[indexPath.item])
        cell.prepareForDisplay()
        
        return cell
    }
}

extension TFTweetsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let width = (collectionView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - CGFloat(numberOfColumns - 1) * flowLayout.minimumInteritemSpacing) / CGFloat(numberOfColumns)
        
        heightCell.frame.size.width = width
        
        return CGSize(width: width, height: heightCell.heightForTweet(feed[indexPath.item]))
        
    }
}
