//
//  FileTableViewCell.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 30/07/2022.
//

import UIKit

class FileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var audioDurationLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
