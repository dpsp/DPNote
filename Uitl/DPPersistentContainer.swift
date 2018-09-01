//
//  DPPersistentContainer.swift
//  DPNote
//
//  Created by Peng Dong on 2018/8/28.
//  Copyright © 2018年 Peng Dong. All rights reserved.
//

import UIKit
import CoreData

class DPPersistentContainer: NSObject {

    public static var instance: DPPersistentContainer = DPPersistentContainer()
    
    var persistentContainer: NSPersistentContainer?
    
    private override init() {
        
    }
    
}
