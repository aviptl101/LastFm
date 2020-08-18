//
//  TrackDetailsViewController.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 17/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit
import SDWebImage

class TrackDetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var listenersLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    var trackInfo: TopTrack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        configureViewWithTrackInfor(trackInfo: trackInfo)
    }
    
    func configureViewWithTrackInfor(trackInfo: TopTrack?) {
        titleLabel.text = trackInfo?.name ?? ""
        artistLabel.text = trackInfo?.artist?.name ?? ""
        rankLabel.text = trackInfo?.rank ?? ""
        listenersLabel.text = trackInfo?.listeners ?? ""
        playCountLabel.text = trackInfo?.playcount ?? ""
        
        var imageUrl: URL?
        if let imageCount = trackInfo?.image.count, imageCount >= 3 {
            imageUrl = trackInfo?.image[2].url
        }
        DispatchQueue.main.async {
            self.imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "person.circle"))
        }
    }
    
    @IBAction func dissmissAction() {
        self.dismiss(animated: false)
    }
    
    @IBAction func openTrackUrl() {
        if let url = trackInfo?.url {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false)
    }
}
