//
//  ChatCell.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 04/01/2021.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var LeftViewPlaceholder: UIView!
    @IBOutlet weak var RightViewPlaceholder: UIView!
    
    @IBOutlet weak var textBubble: UIView!
    @IBOutlet weak var textBody: UILabel!
    @IBOutlet weak var textSenderID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Round TextBubble
        textBubble.layer.cornerRadius = 10.0
        // Cell Clear Background Color
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
