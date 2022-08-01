
//
//  UIViewControllerExtension.swift
//  SnapSkin
//
//  Created by Mohamed Samir on 30/07/2022.
//  Copyright © 2022 macOS. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title : String , message : String , onClick : ((UIAlertAction)->Void)?)
    {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: onClick))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
