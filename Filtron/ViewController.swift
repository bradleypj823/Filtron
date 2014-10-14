//
//  ViewController.swift
//  Filtron
//
//  Created by Jacob Hawken on 10/13/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit


class ViewController: UIViewController, GalleryDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //MARK: Outlets and Properties
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate : GalleryDelegate?

    //MARK: - View Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: - Actions and other functions
    @IBAction func photosPressed(sender: AnyObject)
    {
        let alertController = UIAlertController(title: nil, message: "Photo Options", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let randomImageAction = UIAlertAction(title: "Random Images", style: UIAlertActionStyle.Default)
        { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default)
        { (action) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            { (action) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        { (action) -> Void in
            
        }
        
        alertController.addAction(randomImageAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "SHOW_GALLERY")
        {
            var destinationVC = segue.destinationViewController as GalleryViewController
            destinationVC.delegate = self
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapOnPicture(image: UIImage)
    {
        self.imageView.image = image
    }
}

