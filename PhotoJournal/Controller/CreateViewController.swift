//
//  AddViewController.swift
//  PhotoJournal
//
//  Created by Edward O'Neill on 5/3/20.
//  Copyright © 2020 Edward O'Neill. All rights reserved.
//

import UIKit
import DataPersistence

protocol CreateVCDelegate: class {
    func didUpdate(viewController: CreateViewController)
}

class CreateViewController: UIViewController {
    
    weak var delegate: CreateVCDelegate?
    private let addView = CreateView()
    public var mediaData: Data?
    private var photo: Photo?
    private var dataPersistence: DataPersistence<Photo>
    private var updateBool = false
    
    init(dataPersistence: DataPersistence<Photo>, object: Photo? = nil) {
        self.dataPersistence = dataPersistence
        self.photo = object
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePicked()
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = save
        navigationItem.leftBarButtonItem = customBackButton
        self.navigationController?.navigationBar.isHidden = false
        addView.imagePickerController.delegate = self
        addView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        addView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    lazy private var customBackButton: UIBarButtonItem = {
    [unowned self] in
        return UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(back))
    }()
    
    lazy private var save: UIBarButtonItem = {
        [unowned self] in
        return UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveItem(_:)))
        }()
    
    @objc func saveItem(_ sender: UIBarButtonItem) {
        guard let titleText = addView.titleLabel.text, !titleText.isEmpty, mediaData != nil, let safeMediaData = mediaData else {
            showAlert(title: "Fill Missing Fields", message: "Fill All Fields")
            return
        }
        
        let newPhotoObject = Photo(imageData: safeMediaData, date: Date(), title: titleText, id: UUID().uuidString)
        if updateBool == false {
       try? dataPersistence.createItem(newPhotoObject)
        } else {
            if let object = photo {
            let updatePhotoObject = Photo(imageData: safeMediaData, date: Date(), title: titleText, id: object.id)
                updateObject(object: updatePhotoObject)
            }
        }
        navigationController?.popViewController(animated: true)
            
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateObject(object: Photo) {
        if let oldObject = photo {
                dataPersistence.update(oldObject, with: object)
            delegate?.didUpdate(viewController: self)
        }
    }
    
    private func updatePicked() {
        if photo != nil {
            updateBool = true
            addView.titleLabel.text = photo?.title
            if let photoData = photo?.imageData {
            mediaData = photoData
            addView.imageView.image = UIImage(data: photoData)
            }
            navigationItem.title = "Update"
        } else {
            navigationItem.title = "Create"
        }
    }
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                   if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageData = originalImage.jpegData(compressionQuality: 1.0) {
                    addView.imageView.image = originalImage
                    mediaData = imageData
                   }
               picker.dismiss(animated: true)
    }
}

extension CreateViewController: CreateViewDelegate {
    func cameraButtonPressed() {
        addView.imagePickerController.sourceType = UIImagePickerController.SourceType.camera
        present(addView.imagePickerController, animated: true)
    }
    
    func libraryPressed() {
        addView.imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(addView.imagePickerController, animated: true)
    }
    
}
