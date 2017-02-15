//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Tong Lin on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import AVKit
import AVFoundation
import MobileCoreServices
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let storageManager = FIRStorage.storage()
    let databaseReference = FIRDatabase.database().reference().child("posts")
    let storageReference = FIRStorage.storage().reference().child("images")
    var currentPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        configureConstraints()
    }
    
    func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .popover
        
        // 3. Allow choice of images and movies
        //    Image only is the default
        imagePickerController.mediaTypes = [String(kUTTypeImage)]
        
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func showImagePicker(){
        showImagePickerForSourceType(sourceType: .photoLibrary)
    }
    
    func uploadingImage(sender: UIBarButtonItem){
        print("uploading")
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            if let image = selectedImage.image{
                
                let postRef = self.databaseReference.childByAutoId()
                
                let data = UIImageJPEGRepresentation(image, 0.5)
                
                let metadata = FIRStorageMetadata()
                metadata.cacheControl = "public,max-age=300";
                metadata.contentType = "image/jpeg";
                
                let _ = storageReference.child(postRef.key).put(data!, metadata: metadata, completion: { (metadata, error) in
                    guard metadata != nil else {
                        print("put error")
                        return
                    }
                })
                
                let post: [String: String] = ["comment": self.commentTextField.text,
                            "userId": currentUser.uid]
                
                postRef.setValue(post, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        print(error)
                    }else {
                        print(reference)
                        
                        self.showOKAlert(title: "Done", message: "Upload successful")
                    }
                })
            }else{
                self.showOKAlert(title: "No Image", message: "Please select an image")
            }
        } else {
            self.showOKAlert(title: "Not Logged In", message: "Please log in or register to continue")
        }
    }
    
    func setupViewHierarchy(){
        self.view.backgroundColor = .white
        self.navigationItem.title = "Upload"
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        let rightBarButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(uploadingImage))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        self.view.addSubview(selectedImage)
        self.view.addSubview(commentTextField)
        
    }
    
    func configureConstraints(){
        selectedImage.snp.makeConstraints { (view) in
            view.top.leading.trailing.equalToSuperview()
            view.height.equalTo(self.view.snp.width)
        }
        
        commentTextField.snp.makeConstraints { (view) in
            view.top.equalTo(selectedImage.snp.bottom).offset(10)
            view.leading.equalToSuperview().offset(10)
            view.trailing.equalToSuperview().offset(-10)
            view.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func finishAndUpdate() {
        self.dismiss(animated: true) {
            if let photo = self.currentPhoto{
                self.selectedImage.contentMode = .scaleAspectFill
                self.selectedImage.image = photo
            }
        }
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeImage):
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.currentPhoto = image
            }
        default:
            print("Unknown type")
        }
        
        self.finishAndUpdate()
    }
    
    
    //MARK: - Helper Functions
    func showOKAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: completion)
    }
    
    

    //MARK: - Lazy inits
    lazy var selectedImage: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        view.addGestureRecognizer(tap)
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.image = UIImage(named: "camera_icon")
        view.contentMode = .center
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    lazy var commentTextField: UITextView = {
        let view = UITextView()
        view.text = "Description..."
        view.textAlignment = .left
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
}
