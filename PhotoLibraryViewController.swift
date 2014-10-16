//
//  PhotoLibraryViewController.swift
//  Filtron
//
//  Created by Jacob Hawken on 10/16/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit
import Photos

class PhotoLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    //MARK: - Outlets and Properties
    @IBOutlet weak var collectionView: UICollectionView!
    let imageQueue = NSOperationQueue()
    var backgroundImage : UIImage!
    
    var assetFetchResults: PHFetchResult!
    var assetCollection: PHAssetCollection!
    var imageManager: PHCachingImageManager!
    var assetCellSize: CGSize!
    
    var delegate : GalleryDelegate?
    
    //MARK: - View Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imageManager = PHCachingImageManager()
        self.assetFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        
        var scale = UIScreen.mainScreen().scale
        var flowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        var cellSize = flowLayout.itemSize
        
        self.assetCellSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    //MARK: - Collection View Methods

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return assetFetchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
        
        cell.userInteractionEnabled = false
        cell.imageView.image = nil
        cell.activityIndicator.startAnimating()
        var urlString : String!
        
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        var asset = self.assetFetchResults[indexPath.row] as PHAsset
        
        self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil)
        { (image, info) -> Void in
            if cell.tag == currentTag
            {
                cell.imageView.image = image
                cell.activityIndicator.stopAnimating()
                cell.userInteractionEnabled = true
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as GalleryCell
        var highResImage = imageManager.requestImageForAsset(self.assetFetchResults[indexPath.row] as PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.AspectFill, options: nil)
        { (image, info) -> Void in
            self.delegate?.didTapOnPicture(image)
            println(image.size)
            return ()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Not sure if I need this.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
