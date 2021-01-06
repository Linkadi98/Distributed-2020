//
//  TaskTableViewCell.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 15/12/2020.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = .defaultFont(ofSize: .medium)
        status.font = .defaultFont(ofSize: .medium)
        
        nameLabel.textColor = .text
        status.textColor = .text
        
        separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(name: String, status: String) {
        self.nameLabel.text = name ?? "---"
        self.status.text = status
    }
}
