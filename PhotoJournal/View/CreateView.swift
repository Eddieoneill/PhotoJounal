//
//  AddView.swift
//  PhotoJournal
//
//  Created by Edward O'Neill on 5/3/20.
//  Copyright © 2020 Edward O'Neill. All rights reserved.
//

import UIKit

protocol CreateViewDelegate: class {
    func cameraButtonPressed()
    func libraryPressed()
}

class CreateView: UIView {
    
    weak var delegate: CreateViewDelegate?
    
    public lazy var imagePickerController: UIImagePickerController = {
           let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
           let pickerController = UIImagePickerController()
           return pickerController
       }()
    
    public lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        let camera = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: nil, action: #selector(openCamera(_:)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let photoLibrary = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle"), style: .plain, target: nil, action: #selector(openLibrary(_:)))
        
        tool.barTintColor = .systemGray6
        tool.tintColor = .systemBlue
        tool.items = [camera, flexSpace, photoLibrary]
        return tool
    }()
    
    @objc func openCamera(_ sender: UIBarButtonItem) {
        delegate?.cameraButtonPressed()
    }
    
    @objc func openLibrary(_ sender: UIBarButtonItem) {
        delegate?.libraryPressed()
    }
    
    public lazy var titleLabel: UITextField = {
        let label = UITextField()
        label.layer.borderWidth = 0.5
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.black.cgColor
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.placeholder = " Title"

        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo.fill")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .white
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame:CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .systemBackground
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            toolBar.items![0].isEnabled = false
                     }
        toolBarSetup()
        titleLabelSetup()
        imageViewSetup()
    }
    
    private func toolBarSetup() {
        addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func titleLabelSetup() {
        addSubview(titleLabel)
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 50)
    }
    
    private func imageViewSetup() {
        addSubview(imageView)
        imageView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: toolBar.topAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 20, paddingRight: 15)
        
    }
    
}
