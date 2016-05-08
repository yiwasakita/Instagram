//
//  CommentViewController.swift
//  20160417_Instagram_Practice_01
//
//  Created by tlsmooth89 on 5/7/16.
//  Copyright © 2016 yusuke.iwasaki. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    var firebaseRef: Firebase!
    var postData: PostData!

    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(postData!.id)
    }

    @IBAction func handleCommentButton(sender: AnyObject) {
        /*
        let ud = NSUserDefaults.standardUserDefaults()
        let commentorName = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        */
        let comment = commentTextField.text
        
        // Preparing the data to be saved into the Firebase.
        /*
        let uid = firebaseRef.authData.uid
        
        if postData.isLiked {
            // Removing the ID if it has been already liked.
            var index = -1
            for likeId in postData.likes {
                if likeId == uid {
                    // Keeping the index for removing it.
                    index = postData.likes.indexOf(likeId)!
                    break
                }
            }
            postData.likes.removeAtIndex(index)
        } else {
            postData.likes.append(uid)
        }
        */
        
        let imageString = postData.imageString
        let name = postData.name
        let caption = postData.caption
        let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
        let likes = postData.likes
        
        // Making the dictionary and saving to the Firebase.
        let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes, "comment": comment!]
        let postRef = Firebase(url: CommonConst.FirebaseURL).childByAppendingPath(CommonConst.PostPATH)
        postRef.childByAppendingPath(postData.id).setValue(post)
        
        // HUD
        SVProgressHUD.showSuccessWithStatus("コメント投稿しました")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
