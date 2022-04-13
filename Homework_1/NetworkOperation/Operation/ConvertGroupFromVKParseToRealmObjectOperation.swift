//
//  SaveGroupDataToRealmOperation.swift
//  Homework_1
//
//  Created by Maksim on 10.06.2021.
//

import Foundation
import Realm

class ConvertGroupFromVKParseToRealmObjectOperation<T:Codable>: Operation {
    
    var groupsForRealm: [GroupsRealMObject]? = []
    
    override func main (){
        guard let parsedGroupData = dependencies.first as? ParseGroupDataFromVKOperation<Group>,
              let groups = parsedGroupData.outputData else {
            print("parsedGroupData.outputData - failed")
            return
        }
        for i in 0..<groups.count {
            let community = GroupsRealMObject(group: groups[i])
            groupsForRealm?.append(community)
            
        }
        print("ConvertGroupFromVKParseToRealmObjectOperation - done", groupsForRealm?.count)
    }
}
