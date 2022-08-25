//
//  Ext+ UIViewController.swift
//  Veriff
//
//  Created by Kseniya Zharikova on 27/7/22.
//

import Foundation
import UIKit

protocol PickerControllerDelegate : UIImagePickerControllerDelegate, UINavigationControllerDelegate {}

extension UIViewController {
    func openCamera(delegate: PickerControllerDelegate ) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = delegate
        present(vc, animated: true)
    }
}
