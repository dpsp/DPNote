//
//  ViewController.swift
//  DPNote
//
//  Created by Peng Dong on 2018/8/28.
//  Copyright © 2018年 Peng Dong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showNoteListTouchUpInside(_ sender: Any) {
        
        
    }
    
    @IBAction func addNewNoteUpdateInside(_ sender: Any) {
        if let context = DPPersistentContainer.instance.persistentContainer?.viewContext {
            let note = NSEntityDescription.insertNewObject(forEntityName: "NyanNote", into: context) as! NyanNote
            note.title = "1"
            note.content = "1 content"
            note.timestamp = Date().timeIntervalSince1970
            
            do {
                try context.save()
            } catch {
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

