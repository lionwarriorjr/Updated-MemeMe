//
//  MemesCollectionViewController.swift
//  testImagePicker
//
//  Created by Mohan Devanathan on 7/3/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import Foundation

import UIKit

class MemesCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes = [Meme]()

    override func viewDidLoad() {
        if memes.count == 0 {
            segueToEditor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memeModel
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .Plain, target: self, action: "segueToEditor")
    }
    
    func segueToEditor() {
        self.performSegueWithIdentifier("showEditorFromCollection", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.memes.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
        //construct collection view cell
        //indexPath.item in collectionView instead of indexPath.row
        let currentMeme = self.memes[indexPath.item]
        //cell.setText(currentMeme.topText, bottomString: currentMeme.bottomText)
        
        cell.background?.image = currentMeme.memedImage
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        detailVC.meme = memes[indexPath.item]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
