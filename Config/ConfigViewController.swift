
//
//  ConfigViewController.swift
//  DPNote
//
//  Created by Peng Dong on 2018/9/3.
//  Copyright © 2018 Peng Dong. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cleanTmpDirectory(_ sender: Any) {
        let path = NSTemporaryDirectory()
        let fileManager = FileManager.default
        if let enumerators = fileManager.enumerator(atPath: path) {
            for enumerator in enumerators {
                if let filename = enumerator as? String, (filename.hasSuffix("jpeg") || filename.hasSuffix("jpg")) {
                    do {
                        let nsPath = path as NSString
                        let imagePath = nsPath.appendingPathComponent(filename)
                        try FileManager().removeItem(atPath: imagePath)
                    } catch {
                        view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
