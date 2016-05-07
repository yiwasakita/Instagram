//
//  ViewController.swift
//  20160417_Instagram_Practice_01
//
//  Created by tlsmooth89 on 4/17/16.
//  Copyright © 2016 yusuke.iwasaki. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Initializing Firebase and acquiring the authentication info.
        let firebaseRef = Firebase(url: CommonConst.FirebaseURL)
        let authData = firebaseRef.authData
        
        // "authData == nil" means the user has not been logged in.
        if authData == nil {
            // presentViewController won't display when called inside viewWillAppear; setting it called after the method is completed.
            dispatch_async(dispatch_get_main_queue()) {
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginViewController!, animated: true, completion: nil)
            }
        } else {
            setupTab()
        }
    }
    
    func setupTab() {
        
        // Creating an ESTabBarController instance with the image names.
        let tabBarController = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        // Setting the background colors and selected colors.
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        
        // Adding the created ESTabBarController to the parent ViewController(== self)
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMoveToParentViewController(self)
        
        // Setting the ViewController to display when the tabs are tapped.
        let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("Home")
        let settingViewController = storyboard?.instantiateViewControllerWithIdentifier("Setting")
        
        tabBarController.setViewController(homeViewController, atIndex: 0)
        tabBarController.setViewController(settingViewController, atIndex: 2)
        
        // The central tab as a button.
        tabBarController.highlightButtonAtIndex(1)
        tabBarController.setAction({
            // Displaying the ImageViewController as a modal window when the button is pressed.
            let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelect")
            self.presentViewController(imageViewController!, animated: true, completion: nil)
            }, atIndex: 1)
    }
}

