//
//  GlobalGroupCell.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit

class GlobalGroupCell: UITableViewCell {

    @IBOutlet weak var profilGlobalGroupImgView: RoundedImgView!
    @IBOutlet weak var groupNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(group: GroupsRealMObject){
        self.groupNameLbl.text = group.name
    }
    
   
}
