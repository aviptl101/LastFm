//
//  SearchTrackTableViewCell.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit
import SDWebImage

class SearchTrackTableViewCell: UITableViewCell {
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.layer.cornerRadius = 3
    }
    
    func setTrackInfo(trackCellModel: TrackSearchCellModel) {
        DispatchQueue.main.async {
            self.trackImageView.sd_setImage(with: trackCellModel.trackImage, placeholderImage: UIImage(systemName: "person.circle"))
        }
        titleLabel.text = trackCellModel.trackTitle
        artistLabel.text = trackCellModel.artistTitle
    }
}