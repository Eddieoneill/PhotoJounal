//
//  MainCollectionViewCell.swift
//  PhotoJournal
//
//  Created by Edward O'Neill on 5/3/20.
//  Copyright © 2020 Edward O'Neill. All rights reserved.
//

import UIKit
import AVFoundation

protocol CollectionViewCellDelegate: class {
    func didPressOptionsButton(cell: PhotoCell, object: Photo)
}

class PhotoCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    private var photo: Photo!
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .white
        image.image = UIImage(systemName: "photo")
        return image
    }()
    
    public lazy var descriptionLabel: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.backgroundColor = .white
        label.isEditable = false
        return label
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var moreOptionsButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 10))
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func moreButtonPressed(_ sender: UIButton) {
        animateButtonView(sender)
        delegate?.didPressOptionsButton(cell: self, object: photo)
    }
    
    override init(frame: CGRect) {
           super.init(frame:frame)
           commonSetup()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private func commonSetup() {
        moreOptionsButtonConstraints()
        imageViewConstraints()
        titleLabelConstraints()
        descriptionLabelConstraints()
        backgroundColor = .systemGray6
    }
    
    public func configureCell(object: Photo) {
        photo = object
        imageView.image = UIImage(data: photo.imageData)
        titleLabel.text = photo.title
        descriptionLabel.text = "\(photo.date)"
    }
    
    private func imageViewConstraints() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: moreOptionsButton.bottomAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func moreOptionsButtonConstraints() {
        addSubview(moreOptionsButton)
        NSLayoutConstraint.activate([
            moreOptionsButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            moreOptionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            moreOptionsButton.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    
    private func titleLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 25, paddingLeft: 12, paddingRight: 10, height: 20)
    }
    
    private func descriptionLabelConstraints() {
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
    
}
