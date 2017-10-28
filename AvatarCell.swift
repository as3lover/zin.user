//
//  AvatarCell.swift
//  zin
//
//  Created by Morteza on 6/25/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class AvatarCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var avatar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func set(_ data:ProfileAvatar)
    {
        if let url = data.image
        {
            if let url = URL(string:url)
            {
                avatar.downloadedFrom(url: url)
            }
        }
        
        if let mobile = data.mobile , let fullName = data.fullName
        {
            DispatchQueue.main.async {
                self.label.text = fullName + "\n" + mobile
            }
        }
    }

}



extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
