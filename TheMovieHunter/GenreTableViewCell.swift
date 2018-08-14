//
//  GenreTableViewCell.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/31/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {

    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var switchGenre: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
