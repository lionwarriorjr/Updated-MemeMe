//
//  MemesTableViewController.swift
//  testImagePicker
//
//  Created by Mohan Devanathan on 7/5/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import Foundation

import UIKit

class MemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memeModel
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .Plain, target: self, action: "segueToEditor")
    }
    
    func segueToEditor() {
        self.performSegueWithIdentifier("showEditorFromTable", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        //Configure table-cell
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        detailVC.meme = self.memes[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
