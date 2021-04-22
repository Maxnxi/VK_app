//
//  GroupsCell.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit

class MyGroupsCell: UITableViewCell {

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
        //self.groupProfileImgView.image = group.photo
        
        //let urlString = group.photo50
        
        guard let urlString = group.photo50 as? String else { return }
        let data = try? Data(contentsOf: URL(string: urlString)!)
        
        //let data = try? Data(contentsOf: url)
        guard let image = data else { return }
        groupProfileImgView.image = UIImage(data: image)
    }

}
