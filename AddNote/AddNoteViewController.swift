//
//  AddNoteViewController.swift
//  DPNote
//
//  Created by Peng Dong on 2018/9/3.
//  Copyright © 2018 Peng Dong. All rights reserved.
//

import UIKit
import CoreData

import Toast

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    var photo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.text = nil
        titleTextField.placeholder = "笔记标题"
        contentTextView.text = nil
        
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("保存", for: .normal)
        button.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    
    @IBAction func addPhotoTouchUpInside(_ sender: Any) {
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
    
    @objc func saveNote() {
        guard let noteTitle = titleTextField.text, !noteTitle.isEmpty, let noteContent = contentTextView.text, !noteContent.isEmpty else {
            
            self.view.makeToast("数据不完整")
            
            return
        }
        
        if let context = DPPersistentContainer.instance.persistentContainer?.viewContext {
            let note = NSEntityDescription.insertNewObject(forEntityName: "NyanNote", into: context) as! NyanNote
            note.title = noteTitle
            note.content = noteContent
            note.timestamp = Date().timeIntervalSince1970
            if let image = imagePreview.image {
                note.photo = image.saveLocalImage()
            }
            
            do {
                try context.save()
                view.makeToast("保存成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            } catch {
                view.makeToast("保存失败")
            }
        }
    }
    
}

extension AddNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.photo = image.saveTempImage()
            
            let path = NSTemporaryDirectory() as NSString
            let tempPath = path.appendingPathComponent("\(photo!).jpg")
            self.imagePreview.image = UIImage.init(contentsOfFile: tempPath)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
