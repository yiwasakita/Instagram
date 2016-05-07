//
//  SettingViewController.swift
//  20160417_Instagram_Practice_01
//
//  Created by tlsmooth89 on 4/17/16.
//  Copyright © 2016 yusuke.iwasaki. All rights reserved.
//

import UIKit
import Firebase
import ESTabBarController
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleChangeButton(sender: AnyObject) {
        
        if let name = displayNameTextField.text {
            
            // Without the displayName, displaying the HUD and doing nothing.
            if name.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("表示名を入力してください")
                return
            }
            
            // Saving the displayName into the Firebase.
            let userRef = Firebase(url: CommonConst.FirebaseURL).childByAppendingPath(CommonConst.UserPATH)
            let data = ["name": name]
            userRef.childByAppendingPath("/\(userRef.authData.uid)").setValue(data)
            
            // Saving the displayName into the NSUserDefaults.
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setValue(name, forKey: CommonConst.DisplayNameKey)
            ud.synchronize()
            
            // Notifying the completion of displayName change via the HUD.
            SVProgressHUD.showSuccessWithStatus("表示名を変更しました")
            
            // Closing the keyboard.
            view.endEditing(true)
        }
    }
    
    @IBAction func handleLogoutButton(sender: AnyObject) {
        
        // Logout
        let firebaseRef = Firebase(url: CommonConst.FirebaseURL)
        firebaseRef.unauth()
        
        // Displaying the Login page.
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(loginViewController!, animated: true, completion: nil)
        
        // Having the Home (index = 0) selected in case coming back from the Login page.
        let tabBarController = parentViewController as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Acquiring the displayName from the NSUserDefaults and Setting it int the TextField.
        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        displayNameTextField.text = name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
