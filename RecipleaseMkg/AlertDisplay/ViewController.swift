//
//  ViewController.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 13/03/23.
//

import UIKit

extension UIViewController {
    
    func displayAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
