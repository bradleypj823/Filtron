//
//  CoreDataSeeder.swift
//  Filtron
//
//  Created by Jacob Hawken on 10/14/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSeeder
{
    var managedObjectContext: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext)
    {
        self.managedObjectContext = context
    }
    
    func seedCoreData()
    {
        var sepia = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        sepia.name = "CISepiaTone"
        
        var gaussianBlur = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        gaussianBlur.name = "CIGaussianBlur"
        gaussianBlur.favorite = true
        
        var pixellate = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: managedObjectContext) as Filter
        pixellate.name = "CIPixellate"
        
        var chrome = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: managedObjectContext) as Filter
        chrome.name = "CIPhotoEffectChrome"
        
        var mono = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: managedObjectContext) as Filter
        mono.name = "CIPhotoEffectMono"
        
        var exposureAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: managedObjectContext) as Filter
        exposureAdjust.name = "CIExposureAdjust"
        
        var error: NSError?
        self.managedObjectContext?.save(&error)
        
        if error != nil
        {
            println(error?.localizedDescription)
        }
    }
}