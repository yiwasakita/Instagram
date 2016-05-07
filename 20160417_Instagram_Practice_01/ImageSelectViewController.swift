//
//  ImageSelectViewController.swift
//  20160417_Instagram_Practice_01
//
//  Created by tlsmooth89 on 4/17/16.
//  Copyright © 2016 yusuke.iwasaki. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate {

    @IBAction func handleLibraryButton(sender: UIButton) {
        
        // Opening a picker with the library (camera roll).
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
        
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(pickerController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func handleCameraButton(sender: UIButton) {
        
        // Opening a picker with the camera.
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancelButton(sender: UIButton) {
        // Closing.
        dismissViewControllerAnimated(true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Method called when a photo is taken or selected.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            // Acquiring the taken/selected photo.
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // Having the presentViewController called after the method is done.
            dispatch_async(dispatch_get_main_queue()) {
                // Starting the AdobeImageEditor
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.presentViewController(adobeViewController, animated: true, completion: nil)
            }
        }
        
        // Closing.
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancelPicker(picker: UIImagePickerController) {
        // Closing.
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Called after the AdobeImageEditor finishes photoEditing.
    func photoEditor(editor: AdobeUXImageEditorViewController, finishedWithImage image: UIImage?) {
        // Closing the editor.
        editor.dismissViewControllerAnimated(true, completion: nil)
        
        // Opening the posting page.
        let postViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Post") as! PostViewController
        postViewController.image = image
        presentViewController(postViewController, animated: true, completion: nil)
    }
    
    // Called when the AdobeImageEditor is canceled.
    func photoEditorCanceled(editor: AdobeUXImageEditorViewController) {
        // Closing the editor.
        editor.dismissViewControllerAnimated(true, completion: nil)
    }
}
