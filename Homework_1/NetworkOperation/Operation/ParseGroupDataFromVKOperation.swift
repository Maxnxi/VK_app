//
//  ParseGroupDataFromVKOperation.swift
//  Homework_1
//
//  Created by Maksim on 10.06.2021.
//

import Foundation

class ParseGroupDataFromVKOperation<T:Codable>: Operation {
    
    var outputData: [Group]?
    
    override func main() {
        guard let getGroupDataFromVk = dependencies.first as? GetGroupDataFromVKOperation,
              let data = getGroupDataFromVk.data else { return }
//        do {
        guard let dataParsed = try? JSONDecoder().decode(ResponseGroups.self, from: data).response.items else { return }
        outputData = dataParsed
        print("ParseGroupDataFromVKOperation - done", dataParsed)
//        } catch {
//            debugPrint("error in ParseGroupDataFromVKOperation", error)
//        }
    }
}
