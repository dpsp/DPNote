//
//  UIImage+Path.swift
//  DPNote
//
//  Created by Peng Dong on 2018/8/28.
//  Copyright © 2018年 Peng Dong. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

extension UIImage {
    
    static func loadLocalImage(with name: String) -> UIImage? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return UIImage(contentsOfFile: path.appendingPathComponent("\(name).jpg"))
    }
    
    func saveLocalImage() -> String? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        if let data = UIImageJPEGRepresentation(self, 0.5) {
            let imageName = data.md5().toHexString()
            
            let localPath = path.appendingPathComponent("\(imageName).jpg")
            print(localPath)
            
            do {
                try data.write(to: URL(fileURLWithPath: localPath), options: .atomic)
                
                return imageName
            } catch {
                print("Error writing file: \(error)")
            }
        }
        
        return nil
    }
    
}
