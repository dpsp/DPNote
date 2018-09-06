//
//  FileConvertViewController.swift
//  DPNote
//
//  Created by Peng Dong on 2018/9/4.
//  Copyright © 2018 Peng Dong. All rights reserved.
//

import UIKit
import CoreData

class FileConvertViewController: UIViewController {

    @IBOutlet weak var textview: UITextView!

    var url: URL?
    var isConverting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textview.text = "正在解析\n"
        
        if let url = url, let list = NSMutableArray.init(contentsOf: url) {
            isConverting = true
            
            for item in list {
                if let dict = item as? Dictionary<String, String>, let title = dict["title"] , let content = dict["content"] {
                    if let context = DPPersistentContainer.instance.persistentContainer?.viewContext {
                        let note = NSEntityDescription.insertNewObject(forEntityName: "NyanNote", into: context) as! NyanNote
                        note.title = title
                        note.content = content
                        note.timestamp = Date().timeIntervalSince1970
                        
                        do {
                            try context.save()
                            
                            let log = textview.text + "\(title) finish\n"
                            textview.text = log
                        } catch {
                            view.makeToast("保存失败")
                        }
                    }
                }
            }
            
            let log = textview.text + "all finish\n"
            textview.text = log
            isConverting = false
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        if isConverting {
            view.makeToast("正在解析")
            
            return
        }
        
        dismiss(animated: true) {
            
        }
    }
    
    static func instance() -> FileConvertViewController {
        let bundle = Bundle.init(for: FileConvertViewController.self)
        let storyboard = UIStoryboard.init(name: "Main", bundle: bundle)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "FileConvertViewController") as! FileConvertViewController
        
        return vc
    }
    
}
