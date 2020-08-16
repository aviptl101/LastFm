//
//  MasterViewController.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Configuration.shared.configure(apiKey: "3e993d0279bd62c8160982392010f7bf")
    }
    
    @IBAction func getTracks() {
       
        RequestManager.getTopTracks(endPoint: .getTopTracks(artist: "Cher", autocorrect: false)) { (result) in
            switch result {
            case .success(let value):
                print(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
      return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTrackTableViewCell
      cell.titleLabel.text = "Track.name"
      cell.artistLabel.text = "Artist.name"
      return cell
    }
}
