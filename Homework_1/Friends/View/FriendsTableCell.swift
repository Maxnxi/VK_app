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
            
    func configureCell(friend: User) {
        firstAndLastName.text = friend.fullName
        
        guard let urlString = friend.photo as? String else { return }
        let data = try? Data(contentsOf: URL(string: urlString)!)
        guard let image = data else { return }
        
        avatarImgView.avatarImage = UIImage(data: image)
    }
}
