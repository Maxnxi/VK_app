//
//  FriendsTableCell.swift
//  Homework_1
//
//  Created by Maksim on 22.02.2021.
//

import UIKit

class FriendsTableCell: UITableViewCell {
    
    @IBOutlet weak var firstAndLastName: UILabel!
    @IBOutlet weak var avatarImgView: AvatarView!
        
    func configureCell(friend: Friend) {
        firstAndLastName.text = friend.fullName
        
        avatarImgView.avatarImage = UIImage(named: friend.avatarImg )
        avatarImgView.configureView(nameOfImage: friend.avatarImg)
    }

}
