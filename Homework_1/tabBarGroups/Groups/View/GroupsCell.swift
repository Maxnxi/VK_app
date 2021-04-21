//
//  GroupsCell.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit

class GroupsCell: UITableViewCell {

    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var groupProfileImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configureCell(group: Group){
        self.groupNameLbl.text = group.name
        self.groupProfileImgView.image = group.photo
    }

}
