//
//  GalleryViewController.swift
//  Filtron
//
//  Created by Jacob Hawken on 10/13/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

protocol GalleryDelegate
{
    func didTapOnPicture(image : UIImage)
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    //MARK: Outlets and Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage]()
    var imageQueue = NSOperationQueue()
    var delegate : GalleryDelegate?
    
    //MARK: - View Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    //MARK: CollectionView Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 18
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
        
        cell.imageView.image = nil
        
        cell.activityIndicator.startAnimating()
        
        self.imageQueue.addOperationWithBlock
        { () -> Void in
            let urlString = "http://lorempixel.com/400/400/"
            let url = NSURL(string: urlString)
            let imageData = NSData(contentsOfURL: url)
            var image = UIImage(data: imageData)
            
            NSOperationQueue.mainQueue().addOperationWithBlock(
            { () -> Void in
                cell.imageView.image = image
                cell.activityIndicator.stopAnimating()
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as GalleryCell
        var image = cell.imageView.image
        println("Tapped cell.")
        self.delegate?.didTapOnPicture(image!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
