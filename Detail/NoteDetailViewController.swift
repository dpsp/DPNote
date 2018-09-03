//
//  NoteDetailViewController.swift
//  DPNote
//
//  Created by Peng Dong on 2018/8/28.
//  Copyright © 2018年 Peng Dong. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    public var note: NyanNote?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photo = note?.photo {
            if let image = UIImage.loadLocalImage(with: photo) {
                imageView.image = image
            }
        } else {
            let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
            button.setTitleColor(UIColor.gray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitle("添加", for: .normal)
            button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        }
        
        titleLabel.text = note?.title
        
        contentView.text = note?.content
    }
    
    @objc func addPhoto() {
        let alertViewController = UIAlertController(title: "选择图片", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
        })
        alertViewController.addAction(cancelAction)
        let cameraAction = UIAlertAction(title: "相册", style: .default, handler: { (_) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertViewController.addAction(cameraAction)
        let albumAction = UIAlertAction(title: "相机", style: .default, handler: { (_) in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                return
            }
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertViewController.addAction(albumAction)
        present(alertViewController, animated: true, completion: { })
    }

    @IBAction func showPhoto(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.init(for: ImagePreviewViewController.self))
        if let previewViewController = storyboard.instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewViewController {
            previewViewController.modalPresentationStyle = .overCurrentContext
            
            if let photo = note?.photo {
                previewViewController.image = UIImage.loadLocalImage(with: photo)
            }
            
            present(previewViewController, animated: false) {
                
            }
        }
    }
    
    deinit {
        print("deinit \(self.classForCoder)")
    }
    
}

extension NoteDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            note?.photo = image.saveLocalImage()
            
            do {
                try DPPersistentContainer.instance.persistentContainer?.viewContext.save()
            } catch {
                print("Error saving content: \(error)")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}
