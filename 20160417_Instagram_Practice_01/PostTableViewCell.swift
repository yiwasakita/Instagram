//
//  PostTableViewCell.swift
//  20160417_Instagram_Practice_01
//
//  Created by tlsmooth89 on 5/2/16.
//  Copyright © 2016 yusuke.iwasaki. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var postData: PostData?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Overriding the method for displaying and reflecting the data into the UI
    override func layoutSubviews() {
        
        postImageView.image = postData!.image
        captionLabel.text = "\(postData!.name!) : \(postData!.caption!)"
        print(postData!.caption!)
        
        if postData!.comment != nil {
            // commentLabel.text = "\(postData!.commentorName!) : \(postData!.comment!)"
            commentLabel.text = "\(postData!.comment!)"
        }
        
        let likeNumber = postData!.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.stringFromDate(postData!.date!)
        dateLabel.text = dateString
        
        if postData!.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        }
        
        super.layoutSubviews()
    }
}
