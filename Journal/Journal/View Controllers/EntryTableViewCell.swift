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
        guard let entry = entry else {return}
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyy, HH:mm"
        dateStampLabel.text = dateFormatter.string(from: entry.timestamp!)
//        self.dateStampLabel = entry?.timestamp
        
    }
}
