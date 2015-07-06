//
//  ViewController.swift
//  testImagePicker
//
//  Created by Mohan Devanathan on 6/29/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
    /* !!! if you declare a variable implicitly unwrapped as global and it is not automatically instantiated with the storyboard, you have to instantiate it yourself or else your program will crash !!! */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        topTextField.text = "TOP"
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = NSTextAlignment.Center
    
        //dictionary that can be assigned to a textfield's defaultTextAttributes dictionary to customize text
        let memeTextAttributes = [NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!, NSStrokeWidthAttributeName:5]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //set up left bar button and right bar button in navigation controller auto-generated toolbar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Share", style: .Plain, target: self, action: "shareMeme")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismissCurrentVC")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.bottomToolbar.hidden = false
        
        //must be in viewWillAppear so that share button's enabled property is updated each time the view appears rather than just once in viewDidLoad
        //must force unwrap UIBarButtonItem?
        self.navigationItem.leftBarButtonItem!.enabled = (self.imageView.image == nil) ? false : true
        
        //self.subscribeToKeyboardNotifications()
        // self.subscribeToKeyboardHidden()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        // self.unsubscribeFromKeyboardNotifications()
        // self.unsubscribeFromKeyboardHidden()
    }

    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func shareMeme() {
        let memedImage = generateMemedImage()
        //activity items parameter is the array of data objects to be passed, in this case just memedImage
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
    
        //needs to take closure
        activityVC.completionWithItemsHandler = { (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            var meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, originalImage: self.imageView.image!, memedImage: memedImage) //replaced generate memedImage()
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).memeModel.append(meme)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func dismissCurrentVC() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //TODO: Look into this
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" {
            textField.text = ""
        }
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    //allow text field to be edited
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //resigns keyboard
        textField.resignFirstResponder()
        
        return true;
    }
    
    private func save() {
        //Create the meme
        var meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, originalImage: self.imageView.image!, memedImage: generateMemedImage())
        
        //Add it to memes array on the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memeModel.append(meme)
    }
    
    //memedImage is original image combined with the overlayed text
    func generateMemedImage() -> UIImage {
        
        self.bottomToolbar.hidden = true
        
        //Render view to an image
        //Begin creating an image context
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        //Get current image context
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        //End image current image context
        UIGraphicsEndImageContext()
        
        self.bottomToolbar.hidden = false
        
        return memedImage;
    }
    
    //want a notification parameter as supplied by subscribeToKeyboardNotifications() call
//    func keyboardWillShow(notification: NSNotification) {
//        self.view.frame.origin.y -= getKeyboardHeight(notification)
//    }
//
//    func keyboardWillHide(notification: NSNotification) {
//        self.view.frame.origin.y = self.view.frame.origin.y + getKeyboardHeight(notification)
//    }
//    
//    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
//        //userInfo dictionary holds user information like the size of the keyboard
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
//        return keyboardSize.CGRectValue().height
//    }
//
//    func subscribeToKeyboardHidden() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
//    }
//    
//    func subscribeToKeyboardNotifications() {
//        //notification of when UIKeyboardWillShow
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
//    }
//    
//    func unsubscribeFromKeyboardNotifications() {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name:
//            UIKeyboardWillShowNotification, object: nil)
//    }
//    
//    func unsubscribeFromKeyboardHidden() {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
//    }
}

