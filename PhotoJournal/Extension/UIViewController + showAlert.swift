//
//  File.swift
//  PhotoJournal
//
//  Created by Edward O'Neill on 5/4/20.
//  Copyright © 2020 Edward O'Neill. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showAlert(title: String?, message: String?) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true)
    }
    
}
