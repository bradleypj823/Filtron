//
//  Filter.swift
//  Filtron
//
//  Created by Jacob Hawken on 10/14/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import Foundation
import CoreData

class Filter: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var favorite: NSNumber

}
