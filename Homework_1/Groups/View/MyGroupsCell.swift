//
//  GroupsCell.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit

class MyGroupsCell: UITableViewCell {

    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var groupProfileImgView: RoundedImgView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func configureCell(group: GroupsRealMObject){
//        self.groupNameLbl.text = group.name
//
//        guard let urlString = group.photo as? String else { return }
//        let data = try? Data(contentsOf: URL(string: urlString)!)
//
//        guard let image = data else { return }
//        groupProfileImgView.image = UIImage(data: image)
//    }
   
    //MARK: -> Adapter
//    func configureCell(with group: GroupVK) {
//        self.groupNameLbl.text = group.groupName
//
//        guard let urlString = group.photoUrlString as? String else { return }
//        let data = try? Data(contentsOf: URL(string: urlString)!)
//
//        guard let image = data else { return }
//        groupProfileImgView.image = UIImage(data: image)
//    }
    
    //MARK: -> Factory
    func configureCell(with group: GroupViewModel) {
        self.groupNameLbl.text = group.groupNameText
        self.groupProfileImgView.image = group.iconImage
        }
    
}
