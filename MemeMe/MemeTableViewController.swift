//
//  TableViewController.swift
//  MemeMe
//
//  Created by eiji on 2015/05/05.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	// shared application delegate to access the meme list
	var sharedApp : AppDelegate!
	
	// a table view instance
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.sharedApp = (UIApplication.sharedApplication().delegate as! AppDelegate)
		self.tabBarController?.tabBar.hidden = false

		// The first time a user launches the app, the meme editor view​ appears
		if self.sharedApp.memes.count == 0 {
			// show new meme editor view
			let memeEditorViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
			self.presentViewController(memeEditorViewController, animated: false, completion: nil)
		}
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// update table view
		tableView.reloadData()
		
		updateDeleteButton()
	}

	// methods for operating a table view by UITableViewDataSource protocol

	// ask the number of rows
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// println(sharedApp.memes.count)
		return sharedApp.memes.count
	}
	
	// ask the cell for each row
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as? MemeTableViewCell
		
		let meme = sharedApp.memes[indexPath.row]
		cell?.textLabel?.text = "\(meme.topText) \(meme.bottomText)"

		// set memed image to the specified cell
		let imageView:UIImageView! = cell?.imageView
		//imageView.frame = CGRectMake(0, 0, 300, 240)
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		imageView.image = meme.memedImage
		return cell!
	}
	
	// on selecting each cell
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
		detailViewController.meme = sharedApp.memes[indexPath.row]
		detailViewController.indexPath = indexPath
		self.navigationController!.pushViewController(detailViewController, animated: true)
	}
	

	/*
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

		let cell = tableView.cellForRowAtIndexPath(indexPath) as! MemeTableViewCell
		if cell.eraseButton.on == false {
			return
		}
		//tableView.setEditing(true, animated: false)
		if editingStyle == UITableViewCellEditingStyle.Delete {
			
			tableView.beginUpdates()
			sharedApp.memes.removeAtIndex(indexPath.row)
			cell.eraseButton.on = false
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			tableView.endUpdates()
			tableView.reloadData()
			
			if sharedApp.memes.count == 0 {
				self.navigationItem.leftBarButtonItem?.enabled = false
			}
		}
	}
	*/
	
	// methods to delete meme data
	
	/**
	the action on pressed delete (trash) button. Show the alert asking that deleting meme is OK.
	
	:param: sender an object sent this action
	:returns: none
	*/
	@IBAction func deleteMemes(sender: AnyObject) {
		// ask actually remove selected memes
		var alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete selected memes?", preferredStyle: UIAlertControllerStyle.Alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
			(action) -> Void in
		}
		
		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
			(action) -> Void in
			self.removeMemesFromVisitingCells()
		}
		
		alert.addAction(cancelAction)
		alert.addAction(okAction)
		
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	/**
	Iterate over cells in the table view and check each cell should be removed.
	
	:param: none
	:returns: none
	*/
	func removeMemesFromVisitingCells() {
		// iterate each table view cell
		for (var section = 0; section < self.tableView.numberOfSections(); section++) {
			for (var row = 0; row < self.tableView.numberOfRowsInSection(section); row++) {
				
				let indexPath = NSIndexPath(forRow: row, inSection: section)
				let isRemoved = removeMemesFromACell(indexPath)
				if isRemoved {
					// note: check the same row next time because current cell was removed.
					row--
				}
			}
		}
	}

	/**
	delete a meme from the cell specified with row index.
	
	:param: indexPath specifying row index
	:returns: the result that any cell has been removed
	*/
	func removeMemesFromACell(indexPath: NSIndexPath) -> Bool {
		// for current cell
		let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! MemeTableViewCell
		if cell.eraseButton.on == false {
			return false
		}
		// remove meme data and its cell from the table view
		self.tableView.beginUpdates()
		self.sharedApp.memes.removeAtIndex(indexPath.row)
		cell.eraseButton.on = false // come back to initial state
		// remove the target cell
		self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		self.tableView.endUpdates()
		
		// update table view
		self.tableView.reloadData()
		
		updateDeleteButton()
		
		return true
	}
	
	/**
	update delete button status, active or inactive.
	
	:param: none
	:returns: none
	*/
	func updateDeleteButton() {
		if self.sharedApp.memes.count == 0 {
			self.navigationItem.leftBarButtonItem?.enabled = false
		}
		else {
			self.navigationItem.leftBarButtonItem?.enabled = true
		}
	}
}