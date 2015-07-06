//
//  DetailViewController.swift
//  testImagePicker
//
//  Created by Mohan Devanathan on 7/5/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import Foundation

import UIKit

class DetailViewController: UIViewController {
    //preconfigured property
    var meme: Meme!
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memedImageView.image = meme.memedImage
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}
