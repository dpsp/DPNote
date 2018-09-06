//
//  NoteDetailViewController.swift
//  DPNote
//
//  Created by Peng Dong on 2018/8/28.
//  Copyright © 2018年 Peng Dong. All rights reserved.
//

import UIKit

import Toast

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
            let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 88, height: 44))
            button.setTitleColor(UIColor.gray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitle("添加图片", for: .normal)
            button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        }
        
        titleLabel.text = note?.title
        
        contentView.text = nil
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
            imagePicker.allowsEditing = false
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
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertViewController.addAction(albumAction)
        present(alertViewController, animated: true, completion: { })
    }

    @IBAction func showContent(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.isUserInteractionEnabled {
                button.isUserInteractionEnabled = false
                
                contentView.text = note?.content
            }
        }
    }
    
    @IBAction func showPhoto(_ sender: Any) {
        if note?.photo == nil {
            return
        }
        
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            note?.photo = image.saveLocalImage()
            
            do {
                try DPPersistentContainer.instance.persistentContainer?.viewContext.save()
                
                if let path = note?.photo, let photo = UIImage.loadLocalImage(with: path) {
                    imageView.image = photo
                }
                
                view.makeToast("添加成功")
            } catch {
                print("Error saving content: \(error)")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}
