//
//  MainViewController.swift
//  PhotoJournal
//
//  Created by Edward O'Neill on 5/3/20.
//  Copyright © 2020 Edward O'Neill. All rights reserved.
//

import UIKit
import DataPersistence

class MainViewController: UIViewController {
    
    private let dataPersistence = DataPersistence<Photo>(filename: "photos.plist")
    private let mainView = MainView()
    
    var photos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.mainView.collectionview.reloadData()
            }
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        mainView.delegate = self
        dataPersistence.delegate = self
        mainView.collectionview.delegate = self
        mainView.collectionview.dataSource = self
        mainView.collectionview.register(PhotoCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        getPhotos()
    }
    
    private func getPhotos() {
        do {
            photos = try dataPersistence.loadItems()
        } catch {
            showAlert(title: "failed to fetch", message: "failed: \(error)")
        }
    }
    
    private func deletePhoto(_ object: Photo) {
        guard let index = photos.firstIndex(of: object) else { return }
        
        do {
            try dataPersistence.deleteItem(at: index)
        } catch {
            showAlert(title: "failed to delete", message: "\(error)")
        }
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved = photos[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? PhotoCell else { fatalError() }
        cell.configureCell(object: saved)
        cell.delegate = self
        return cell
    }
    
}

extension MainViewController: DataPersistenceDelegate {
    func didSaveItem<Element>(_ persistenceHelper: DataPersistence<Element>, item: Element) where Element : Decodable, Element : Encodable, Element : Equatable {
        getPhotos()
    }
    
    func didDeleteItem<Element>(_ persistenceHelper: DataPersistence<Element>, item: Element) where Element : Decodable, Element : Encodable, Element : Equatable {
        getPhotos()
    }
}

extension MainViewController: CollectionViewCellDelegate {
    func didPressOptionsButton(cell: PhotoCell, object: Photo) {
        let title = "Select"
        let message = "Please select what you want to do"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (alertAction) in
            let vc = CreateViewController(dataPersistence: self.dataPersistence, object: object)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            self.deletePhoto(object)
        }
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)
        alertController.addAction(delete)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController,animated: true)
        }
        
    }
}

extension MainViewController: MainViewDelegate {
    func addTapped() {
        navigationController?.pushViewController(CreateViewController(dataPersistence: dataPersistence), animated: true)
    }
}

extension MainViewController: CreateVCDelegate {
    func didUpdate(viewController: CreateViewController) {
        getPhotos()
    }
}
