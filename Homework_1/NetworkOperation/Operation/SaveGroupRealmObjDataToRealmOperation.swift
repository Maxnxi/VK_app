//
//  SaveGroupRealmObjDataToRealmOperation.swift
//  Homework_1
//
//  Created by Maksim on 10.06.2021.
//

import Foundation
import Realm

class SaveGroupRealmObjDataToRealmOperation<T:Codable> : Operation {
    
    let realMServices = RealMServices()
    
    override func main() {
        guard let convertedToRealmData = dependencies.first as? ConvertGroupFromVKParseToRealmObjectOperation<GroupsRealMObject>,
              let data = convertedToRealmData.groupsForRealm else { return }
        realMServices.saveGroupsData(data)
        print("Completed Saving")
    }
    
}
