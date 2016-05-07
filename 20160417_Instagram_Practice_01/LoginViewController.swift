//
//  LoginViewController.swift
//  20160417_Instagram_Practice_01
//
//  Created by tlsmooth89 on 4/17/16.
//  Copyright © 2016 yusuke.iwasaki. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    var firebaseRef: Firebase!
    
    @IBAction func handleLoginButton(sender: AnyObject) {
        
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            
            // Do nothing, show the HUD, and just return if either the address or the password isEmpty.
            if address.characters.isEmpty || password.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必要項目を入力してください")
                return
            }
            
            // Displaying the HUD.
            SVProgressHUD.show()
            
            firebaseRef.authUser(address, password: password, withCompletionBlock: { error, authData in
                if error != nil {
                    // Error.
                    SVProgressHUD.showErrorWithStatus("エラー")
                } else {
                    
                    // Saving the displayName, which is acquired from the Firebase, to NSUserDefaults.
                    let userRef = self.firebaseRef.childByAppendingPath(CommonConst.UserPATH)
                    let uidRef = userRef.childByAppendingPath(authData.uid)
                    uidRef.observeSingleEventOfType(FEventType.Value, withBlock: {snapshot in
                        
                        if let displayName = snapshot.value.objectForKey("name") as? String {
                            self.setDisplayName(displayName)
                        }
                        
                        // Dismissing the HUD.
                        SVProgressHUD.dismiss()
                        
                        // Closing the page.
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            })
        }
    }
    
    // Method called when the Account Creation button is tapped.
    @IBAction func handleCreateAccountButton(sender: AnyObject) {
        
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            // Do nothing and just return if either the address, the password, or the displayName isEmpty.
            if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必要項目を入力してください")
                return
            }
            
            // Displaying the HUD.
            SVProgressHUD.show()
            
            firebaseRef.createUser(address, password: password, withValueCompletionBlock: { error, result in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus("エラー")
                } else {
                    // If the new user accout can be made, let the new user login.
                    self.firebaseRef.authUser(address, password: password, withCompletionBlock: { error, authData in
                        if error != nil {
                            SVProgressHUD.showErrorWithStatus("エラー")
                        } else {
                            // Saving the displayName to the Firebase.
                            let usersRef = self.firebaseRef.childByAppendingPath(CommonConst.UserPATH)
                            let data = ["name": displayName]
                            usersRef.childByAppendingPath("/\(authData.uid)").setValue(data)
                            
                            // Saving the displayName to NSUserDefaults
                            self.setDisplayName(displayName)
                            
                            // Dismissing the HUD.
                            SVProgressHUD.dismiss()
                            
                            // Closing the view.
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    })
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initializing the Firebase
        firebaseRef = Firebase(url: CommonConst.FirebaseURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Setting the DisplayName to NSUserDefaults
    func setDisplayName(name: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
        ud.synchronize()
    }
}
