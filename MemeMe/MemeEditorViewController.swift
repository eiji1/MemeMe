//
//  ViewController.swift
//  MemeMe
//
//  Created by eiji on 2015/05/04.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
	UITextFieldDelegate
{
	
	// textfields
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!

	// buttons
	@IBOutlet weak var cameraBarButton: UIBarButtonItem!
	@IBOutlet weak var imagePickerView: UIImageView!
	@IBOutlet weak var shareBarButton: UIBarButtonItem!

	// bars
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var toolBar: UIToolbar!
	
	override func viewWillAppear(animated: Bool) {
		// to appear software keyboard
		self.subscribeToKeyboardNotifications()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		// to disapper keyboard
		self.unsubscribeFromKeyboardNotifications()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// disabe camera button if camera not available
		cameraBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		
		// setup meme text string format easy to read
		let memeTextAttributes = [
			NSStrokeColorAttributeName: UIColor.whiteColor(),
			NSForegroundColorAttributeName: UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
			NSStrokeWidthAttributeName: 0.0
		]
		// top textfield
		topTextField.text = "TOP"
		topTextField.textColor = UIColor.whiteColor()
		topTextField.textAlignment = NSTextAlignment.Center
		topTextField.defaultTextAttributes = memeTextAttributes
		topTextField.delegate = self
		// bottom textfield
		bottomTextField.text = "BOTTOM"
		bottomTextField.textAlignment = NSTextAlignment.Center
		bottomTextField.textColor = UIColor.whiteColor()
		bottomTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.delegate = self
		
	}
	
	/**
	close the meme editor view.
	
	:param: none
	:returns: none
	*/
	@IBAction func dismiss() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// image picker
	
	/**
	Pick an image from photo library.
	
	:param: sender object sent this action
	:returns: none
	*/
	@IBAction func pickAnImageFromAlbum(sender: AnyObject) {
		pickAnImageFrom(UIImagePickerControllerSourceType.PhotoLibrary)
	}
	
	/**
	Pick an image from camera.
	
	:param: sender object sent this action
	:returns: none
	*/
	@IBAction func pickAnImageFromCamera(sender: AnyObject) {
		pickAnImageFrom(UIImagePickerControllerSourceType.Camera)
	}
	
	/**
	Pick an image from specified source kind.
	
	:param: sourceType the place where an image will be picked
	:returns: none
	*/
	func pickAnImageFrom(sourceType: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = sourceType
		self.presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	// methods from UIImagePickerControllerDelegate
	
	// managing image picker behaviour
	func imagePickerController(picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		
		self.imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
		
		self.dismissViewControllerAnimated(true, completion: {
			// rotate screen to left
			let value = UIInterfaceOrientation.LandscapeLeft.rawValue
			UIDevice.currentDevice().setValue(value, forKey: "orientation")
			})
		// set picked image to whole screen
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.imagePickerView.image = image
		}
	}
	
	// methods from UITextFieldDelegate
	
	func textFieldDidBeginEditing(textField: UITextField) {
		textField.text = ""
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	/**
	show a keyboard while bottom textfield is edited
	
	:param: notification tell this view controller will show a keyboard
	:returns: none
	*/
	func keyboardWillShow(notification: NSNotification) {
		if bottomTextField.isFirstResponder() {
			// shift view frame origin
			self.view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	
	/**
	hide a keyboard for bottom textfield
	
	:param: notification tell this view controller will hide a keyboard
	:returns: none
	*/
	func keyboardWillHide(notification: NSNotification) {
		if bottomTextField.isFirstResponder() {
			// unshift view frame origin
			self.view.frame.origin.y += getKeyboardHeight(notification)
		}
	}
	
	/**
	get keyboard height in pixels
	
	:param: notification notifications on showing or hiding keyboards.
	:returns: height in pixels of keyboard frame area
	*/
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.CGRectValue().height
	}

	/**
	subscribe keyboard related notifications, observing 'UIKeyboardWillShowNotification' and 'UIKeyboardWillHideNotification'
	
	:param: none
	:returns: none
	*/
	func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
	}
	
	/**
	quit subscribing keyboard related notifications, 'UIKeyboardWillShowNotification' and 'UIKeyboardWillHideNotification'.
	
	:param: none
	:returns: none
	*/
	func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}

	// saving a memed image
	
	/**
	share memed image on pressed shared button.
	
	:param: sender event sender
	:returns: none
	*/
	@IBAction func shareMeme(sender: AnyObject) {

		// generate the meme data
		let newMeme = Meme( topText: topTextField.text!,
			bottomText: bottomTextField.text!,
			image: self.imagePickerView.image, memedImage: generateMemedImage())
		
		// launch an activity view controller
		let ativityViewController = UIActivityViewController(activityItems: [newMeme.memedImage], applicationActivities: nil)
		// completion handler for the activity
		ativityViewController.completionWithItemsHandler = {
			(activityType, completed:Bool, returnedItems:Array!, error:NSError!) in
			if (completed) {
				// save new meme data to the shared application
				let sharedApp = (UIApplication.sharedApplication().delegate as! AppDelegate)
				sharedApp.memes.append(newMeme)
				// dismiss this meme editor view and show sent memes view (table view) immediately
				self.dismiss()
			}
		}
		self.presentViewController(ativityViewController, animated: true, completion: nil)

	}
	
	/**
	generate a meme image using screen snapshots.
	
	:param: none
	:returns: a memed image
	*/
	func generateMemedImage() -> UIImage {
		
		// take a screen snapshot
		UIGraphicsBeginImageContext(self.view.frame.size)
		self.view.drawViewHierarchyInRect(self.view.frame,
			afterScreenUpdates: true)
		let snapshotImage : UIImage =
		UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		// calculate trimmed part of the snapshot image
		let headerHeight = self.navigationBar.frame.height
		let footerHeight = self.toolBar.frame.height
		
		let adjustedOrigin = CGPoint(x: self.view.frame.origin.x,
			y: self.view.frame.origin.y - headerHeight)
		let adjustedSize = CGSize(width: self.view.frame.width,
			height: self.view.frame.height - (headerHeight + footerHeight))
		
		// trim part of snapshot image
		UIGraphicsBeginImageContext(adjustedSize)
		snapshotImage.drawAtPoint(adjustedOrigin)
		let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return memedImage
	}
	
}

