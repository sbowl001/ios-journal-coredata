//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Stephanie Bowles on 7/11/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateStampLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    var entry: Entry? {
        didSet{
            self.updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateViews() {
        self.titleLabel.text = entry?.title
        self.bodyLabel.text = entry?.bodyText
//        self.dateStampLabel = entry?.timestamp
        
    }
}
