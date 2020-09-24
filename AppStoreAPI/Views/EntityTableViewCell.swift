//
//  EntityTableViewCell.swift
//  AppStoreAPI
//
//  Created by Jason Koceja on 9/24/20.
//

import UIKit

class EntityTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var entityThumbnailImageView: UIImageView!
    @IBOutlet weak var entityTitleLabel: UILabel!
    @IBOutlet weak var entityDetailLabel: UILabel!
    
    // MARK: - Properties
    
    var musicItem: MusicItem?
    var appItem: AppItem?
    
    // MARK: - Helpers
    
    func updateViews() {
        var url: URL?
        
        if let musicItem = musicItem {
            entityTitleLabel.text = musicItem.trackName
            entityDetailLabel.text = musicItem.artistName
            url = musicItem.artworkUrl100
        } else if let appItem = appItem {
            entityTitleLabel.text = appItem.trackName
            entityDetailLabel.text = appItem.description
            url = appItem.artworkUrl100
        }
        
        self.entityThumbnailImageView.image = nil
        if let url = url {
            AppStoreItemController.fetchThumbnailFrom(url: url) { (result) in
                switch result {
                    case .success(let entityImage):
                        DispatchQueue.main.async {
                            self.entityThumbnailImageView.image = entityImage
                        }
                    case .failure(let error):
                        print("Error [\(#function):\(#line)] -- \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
}
