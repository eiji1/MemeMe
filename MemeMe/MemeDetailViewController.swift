//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by eiji on 2015/05/14.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

	// meme data to show
	var meme: Meme!
	// what index in the table or collections
	var indexPath: NSIndexPath!
	
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// disable default UI rendering process,
		// if not inappropriate line will be drawn at the top of toolbar.
		class CustomToolbar :UIToolbar{
			private override func drawRect(rect: CGRect) {}
		}
		
		// create a toolbar
		let toolbar = CustomToolbar(frame:CGRectMake(0,0,80,44))
		toolbar.autoresizingMask = UIViewAutoresizing.FlexibleHeight
		toolbar.translucent = true
		
		// new bar button item including a toolbar
		var toolbarButton = UIBarButtonItem(customView: toolbar)

		// additional UI buttons which are actually used on this view
		var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "launchMemeEditor")
		var deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMeme")

		// register buttons to the toolbar
		let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
		toolbar.setItems([deleteButton, space, space, editButton], animated: false)
		
		// locate the toolbar at the right end of navigation item bar.
		self.navigationItem.rightBarButtonItem = toolbarButton
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		self.tabBarController?.tabBar.hidden = false
		
		// image view
		self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
		self.imageView!.image = self.meme.memedImage
		
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.tabBarController?.tabBar.hidden = false
	}
	
	/**
	On pressed edit (add) button.
	
	:param: none
	:returns: none
	*/
	func launchMemeEditor() {
		// get editor view controller
		let memeEditorViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
		self.presentViewController(memeEditorViewController, animated: false, completion: nil)
		// dismmis detail view and show the table view on coming back from editor view
		self.navigationController!.popViewControllerAnimated(true)
	}
	
	/**
	On pressed delete (trash) button.
	
	:param: none
	:returns: none
	*/
	func deleteMeme() {
		// show alart message asking that deleting meme is OK.
		var alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this meme?", preferredStyle: UIAlertControllerStyle.Alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
			(action) -> Void in
		}
		
		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
			(action) -> Void in
			// remove a meme data
			let sharedApp = (UIApplication.sharedApplication().delegate as! AppDelegate)
			sharedApp.memes.removeAtIndex(self.indexPath.row)
			// dismmis detail view and return to the table view on coming back from editor view
			self.navigationController!.popViewControllerAnimated(true)
		}
		
		alert.addAction(cancelAction)
		alert.addAction(okAction)
		
		self.presentViewController(alert, animated: true, completion: nil)
		
	}
	
}