//
//  GroupViewModelFactory.swift
//  Homework_1
//
//  Created by Maksim on 22.07.2021.
//

import UIKit

class GroupViewModelFactory {
    func constructViewModel(from groups: [GroupVK]) -> [GroupViewModel] {
        return groups.compactMap { getViewModel(from: $0) }
    }
    
    private func getViewModel(from group: GroupVK) -> GroupViewModel {
        let groupName = group.groupName
        
        let urlString = group.photoUrlString
        let data = try? Data(contentsOf: URL(string: urlString)!)
        guard let imageData = data else {
            print("Error in GroupViewModelFactory")
            return GroupViewModel(groupNameText: groupName, iconImage: UIImage(named: "profileDefault"))
        }
        let image = UIImage(data: imageData)
        let group = GroupViewModel(groupNameText: groupName, iconImage: image)
        return group
    }
}
