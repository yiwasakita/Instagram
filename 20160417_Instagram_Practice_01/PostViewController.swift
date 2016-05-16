//
//  PostViewController.swift
//  20160417_Instagram_Practice_01
//
//  Created by tlsmooth89 on 4/17/16.
//  Copyright © 2016 yusuke.iwasaki. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func handlePostButton(sender: AnyObject) {
        
        let postRef = Firebase(url: CommonConst.FirebaseURL).childByAppendingPath(CommonConst.PostPATH)
        
        // Acquiring the image from the ImageView.
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
        
        // Acquring the displayName from the NSUserDefaults.
        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        
        // Acquring the time.
        let time = NSDate.timeIntervalSinceReferenceDate()
        
        // Default comment.
        let comment = "コメントどうぞ！"
        
        // Making a dictionary and saving it to the Firebase.
        let postData = ["caption": textField.text!, "image": imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength), "name":name, "time":time, "comment":comment]
        postRef.childByAutoId().setValue(postData)
        
        // Displaying completion of posting on HUD.
        SVProgressHUD.showSuccessWithStatus("投稿しました")
        
        // Closing all modals.
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        // Closing the window.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Displaying the received image.
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
