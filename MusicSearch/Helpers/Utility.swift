//
//  Utility.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 17/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

class Utility {
    
    static func showAlert(title: String = "Alert", message: String = "Server Error", for view: UIViewController?, completion: (() -> Void)? = nil) {
        guard let view = view else { return }
        
        let messageCapitalized = message.capitalized
        
        let alert = UIAlertController(title: title, message: messageCapitalized, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            completion?()
        }))
        
        /*
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
        }))
        
        alert.addAction(UIAlertAction(title: "Destructive", style: .destructive, handler: { (_) in
            print("You've pressed the destructive")
        }))
        */
        view.present(alert, animated: true, completion: nil)
    }
    
    static func getEncoded<Model: Encodable>(_ obj: Model) -> Data? {
        return try? JSONEncoder().encode(obj)
    }
}

extension UIColor {
    static let lastfmPink = UIColor(red: 255.0/255.0, green: 12.0/255.0, blue: 83.0/255.0, alpha: 1.0)
}
