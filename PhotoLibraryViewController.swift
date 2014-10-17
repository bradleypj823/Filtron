//
//  PhotoLibraryViewController.swift
//  Filtron
//
//  Created by Jacob Hawken on 10/16/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import QuartzCore

class PhotoLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    //MARK: - Outlets and Properties
    @IBOutlet weak var collectionView: UICollectionView!
    let imageQueue = NSOperationQueue()
    var flowlayout : UICollectionViewFlowLayout!
    var assetCollection: PHAssetCollection!
    var imageManager: PHCachingImageManager!
    var assetFetchResults: PHFetchResult!
    var assetCellSize: CGSize!
    var delegate : GalleryDelegate?
    
    var stillImageOutput = AVCaptureStillImageOutput()
    
    //MARK: - View Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imageManager = PHCachingImageManager()
        self.assetFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        
        var scale = UIScreen.mainScreen().scale
        self.flowlayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        var cellSize = flowlayout.itemSize
        
        //Pinch recognizer
        var pinch = UIPinchGestureRecognizer(target: self, action: "pinchAction:")
        self.collectionView.addGestureRecognizer(pinch)
        
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
    
    //MARK: - Actions
    
    func pinchAction(pinch : UIPinchGestureRecognizer)
    {
        println("Observing pinch...")
        
        
        if pinch.state == UIGestureRecognizerState.Ended
        {
            println("...pinch ended.")
            println(pinch.velocity)
            self.collectionView.performBatchUpdates(
            { () -> Void in
                if pinch.velocity > 0
                {
                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 2, height: self.flowlayout.itemSize.height * 2)
                    println(self.flowlayout.itemSize.width)
                }
                else
                {
                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 0.5, height: self.flowlayout.itemSize.height * 0.5)
                    println(self.flowlayout.itemSize.width)
                }
            }, completion: nil )
        }
        
    }
    
    //MARK: - Not sure if I need this.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
