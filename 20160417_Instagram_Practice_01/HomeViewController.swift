//
//  HomeViewController.swift
//  20160417_Instagram_Practice_01
//
//  Created by tlsmooth89 on 4/17/16.
//  Copyright © 2016 yusuke.iwasaki. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var firebaseRef: Firebase!
    var postArray: [PostData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Preparing the UITableView.
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Preparing the Firebase
        firebaseRef = Firebase(url: CommonConst.FirebaseURL)
        
        // When new postData is added, adding it to the postArray and reloading the tableView.
        firebaseRef.childByAppendingPath(CommonConst.PostPATH).observeEventType(FEventType.ChildAdded, withBlock: { snapshot in
            
            // Setting the received data with making a new PostData class.
            let postData = PostData(snapshot: snapshot, myId: self.firebaseRef.authData.uid)
            self.postArray.insert(postData, atIndex: 0)
            
            // Reloading the tableView.
            self.tableView.reloadData()
        })
        
        // When postData is changed, deleting the data from the postArray, adding the new data to the postArray, and reloading the tableView.
        firebaseRef.childByAppendingPath(CommonConst.PostPATH).observeEventType(FEventType.ChildChanged, withBlock: { snapshot in
            
            // Setting the received data with making a new PostData class.
            let postData = PostData(snapshot: snapshot, myId: self.firebaseRef.authData.uid)
            
            // Picking the data with the same ID from the postArray.
            var index: Int = 0
            for post in self.postArray {
                if post.id == postData.id {
                    index = self.postArray.indexOf(post)!
                    break
                }
            }
            
            // Deleting the data.
            self.postArray.removeAtIndex(index)
            
            // Adding the renewed data.
            self.postArray.insert(postData, atIndex: index)
            
            // Reloadking the applicable cell oon the tableView.
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource Protocol Methods.
    // Method to return the number of cells/data.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    // Method to return each cell content.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Acquiring reusable cells and setting the data.
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostTableViewCell
        cell.postData = postArray[indexPath.row]
        
        // Setting the button action inside the cell.
        cell.likeButton.addTarget(self, action: #selector(HomeViewController.handleButton(_:event:)), forControlEvents: UIControlEvents.TouchUpInside)
        // Old school of the above.
        // cell.likeButton.addTarget(self, action:"handleButton:event:", forControlEvents:  UIControlEvents.TouchUpInside)
        
        // Re-layouting with the new number of rows.
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Changing the cells' heights automatically with the Auto Layout.
        return UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDelegate Protocol Methods.
    // Method to be executed when each cell is selected.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselecting the cell without doing anything if the cell is tapped.
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Method to tell a cell is deletable.
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // Method to be executed when the Delete button is pressed.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // Method to be called when the button inside a cell is tapped.
    func handleButton(sender: UIButton, event:UIEvent) {
        
        // Acquiring the cell index of the tapped cell.
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        // Acquiring the index data of the tapped from the postArray.
        let postData = postArray[indexPath!.row]
        
        // Preparing the data to be saved into the Firebase.
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
        
        let imageString = postData.imageString
        let name = postData.name
        let caption = postData.caption
        let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
        let likes = postData.likes
        
        // Making the dictionary and saving to the Firebase.
        let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes]
        let postRef = Firebase(url: CommonConst.FirebaseURL).childByAppendingPath(CommonConst.PostPATH)
        postRef.childByAppendingPath(postData.id).setValue(post)
    }
}