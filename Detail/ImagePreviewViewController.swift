//
//  ImagePreviewViewController.swift
//  DPNote
//
//  Created by Peng Dong on 2018/8/28.
//  Copyright © 2018年 Peng Dong. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = .scaleAspectFit
        
        if let image = image {
            imageView.image = image
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: false) {
            
        }
    }
    
    deinit {
        print("deinit \(self.classForCoder)")
    }
    
}
