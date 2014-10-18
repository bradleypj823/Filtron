//
//  AVFoundationCameraViewController.swift
//  CFImageFilterSwift
//
//  Created by Bradley Johnson on 9/22/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import QuartzCore

class AVFoundationCameraViewController: UIViewController
{

    @IBOutlet weak var capturePreviewImageView: UIImageView!
    
    var stillImageOutput = AVCaptureStillImageOutput()
    var delegate : GalleryDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let xDimension = CGFloat(self.view.frame.size.width * 0.9)
        let xPosition = CGFloat(self.view.frame.size.width/2) - (xDimension/2)
        let yPosition = CGFloat(self.view.frame.size.height/2) - (xDimension/2)
        previewLayer.frame = CGRectMake(xPosition, yPosition, xDimension, xDimension)
        previewLayer.masksToBounds = true
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as AVCaptureDeviceInput!
        if input == nil
        {
            println("bad!")
        }
        captureSession.addInput(input)
        var outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        self.stillImageOutput.outputSettings = outputSettings
        captureSession.addOutput(self.stillImageOutput)
        captureSession.startRunning()
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        //reset position of preview layer
    }
    
    override func didReceiveMemoryWarning(){super.didReceiveMemoryWarning()}

    @IBAction func capturePressed(sender: AnyObject)
    {
        var videoConnection : AVCaptureConnection?
        for connection in self.stillImageOutput.connections
        {
            if let cameraConnection = connection as? AVCaptureConnection
            {
                for port in cameraConnection.inputPorts
                {
                    if let videoPort = port as? AVCaptureInputPort
                    {
                        if videoPort.mediaType == AVMediaTypeVideo
                        {
                            videoConnection = cameraConnection
                            break;
                        }
                    }
                }
            }
            if videoConnection != nil
            {
                break;
            }
        }
        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler:
        {(buffer : CMSampleBuffer!, error : NSError!) -> Void in
            var data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            var image = UIImage(data: data)
            self.capturePreviewImageView.image = image
            println(image.size)
            self.delegate?.didTapOnPicture(image)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}
