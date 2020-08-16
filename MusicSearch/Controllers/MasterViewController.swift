//
//  MasterViewController.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Configuration.shared.configure(apiKey: "3e993d0279bd62c8160982392010f7bf")
    }
    
    @IBAction func getTracks() {
       
        RequestManager.getTrackInfo(endPoint: .getTrackInfo(track: "being", autocorrect: false)) { (result) in
            switch result {
            case .success(let value):
                print(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
