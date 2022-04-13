//
//  Adapter.swift
//  Homework_1
//
//  Created by Maksim on 21.07.2021.
//

import Foundation
import RealmSwift

class GroupAdapter {
    private let apiService = ApiVkServices()
    private var realmNotificationToken = NotificationToken()//*/ : [String: NotificationToken] = [:]
    
    func getGroups(completion: @escaping([GroupVK]) -> Void) {
        guard let realm = try? Realm() else { return }
              let realmGroup = realm.objects(GroupsRealMObject.self)
              
        //(ofType: GroupsRealMObject.self, forPrimaryKey: id.self)
        //realmNotificationToken.invalidate()// .stop
        
        let token = realmGroup.observe { [weak self] (changes) in
            switch changes {
            case .update(let realmGroups, _, _, _):
                var groupsVK: [GroupVK] = []
                realmGroup.forEach { groupRlm in
                    groupsVK.append(self?.getGroup(from: groupRlm) ?? GroupVK(groupName: "error", photoUrlString: "error"))
                }
                self?.realmNotificationToken.invalidate()
                completion(groupsVK)
                
            case .initial:
                break
            case .error(let err):
            print(err.localizedDescription)
            }
        }
        realmNotificationToken = token
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else { return }
        apiService.getUserGroups(userId: userId, accessToken: accessToken)
    }
    
    private func getGroup(from realmGroup: GroupsRealMObject) -> GroupVK {
        return GroupVK(groupName: realmGroup.name, photoUrlString: realmGroup.photo)
    }
}
