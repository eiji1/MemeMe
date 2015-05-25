//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by eiji on 2015/05/05.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
	
	// shared application delegate to access the meme list
	var sharedApp : AppDelegate!
	
	// collection view instance
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.sharedApp = (UIApplication.sharedApplication().delegate as! AppDelegate)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// update delete button
		if sharedApp.memes.count == 0 {
			self.navigationItem.leftBarButtonItem?.enabled = false
		}
		else {
			self.navigationItem.leftBarButtonItem?.enabled = true
		}
		
		self.tabBarController?.tabBar.hidden = false
		
		// update collection view
		self.collectionView.reloadData()
	}
	
	// methods for operating a collection view by UICollectionViewDataSource protocol

	// returns the number of collection view cells
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.sharedApp.memes.count
	}

	// render a collection cell specified with indexPath
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
		let meme = sharedApp.memes[indexPath.row]
		
		// set the image
		cell.memeImageView.contentMode = UIViewContentMode.ScaleAspectFit
		cell.memeImageView?.image = meme.memedImage
		return cell
	}
	
	// on selecting a collection view cell
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
	{
		let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
		detailController.meme = sharedApp.memes[indexPath.row]
		detailController.indexPath = indexPath
		self.navigationController!.pushViewController(detailController, animated: true)
	}
	
	// methods to delete meme data
	
	/**
	the action on pressed delete (trash) button. Show an alert message asking that deleting selected memes is OK.
	
	:param: sender sender object
	:returns: none
	*/
	@IBAction func deleteCollectionViewCell(sender: AnyObject) {
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
	Remove a meme from each cell.
	
	:param: sender sender object
	:returns: none
	*/
	func removeMemesFromVisitingCells() {
		// iterate every visible cell
		for cell in self.collectionView.visibleCells() as! [MemeCollectionViewCell] {
			if cell.eraseButton.on == true {
				// remove meme data and its collection view cell
				let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
				self.sharedApp.memes.removeAtIndex(indexPath.row)
				cell.eraseButton.on = false // return to initial state
				// remove the target cell
				self.collectionView.deleteItemsAtIndexPaths([indexPath])
			}
		}
	}
}
