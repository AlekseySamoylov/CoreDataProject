//
//  Item+CoreDataClass.swift
//  CoreDataProject
//
//  Created by ALEKSEY SAMOYLOV on 10/7/16.
//  Copyright © 2016 ALEKSEY SAMOYLOV. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
        
    }
}
