//
//  Note+CoreDataProperties.swift
//  DPNote
//
//  Created by Peng Dong on 2018/8/28.
//  Copyright © 2018年 Peng Dong. All rights reserved.
//
//

import Foundation
import CoreData


extension NyanNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NyanNote> {
        return NSFetchRequest<NyanNote>(entityName: "NyanNote")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var photo: String?
    @NSManaged public var timestamp: Double
    
}
