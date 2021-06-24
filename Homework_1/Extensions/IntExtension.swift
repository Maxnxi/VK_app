//
//  IntExtension.swift
//  Homework_1
//
//  Created by Maksim on 24.06.2021.
//

import Foundation

extension Int {
    
    func fromIntToDateFormatToCell(date:Int) -> String {
        let myDate = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let stringDate = dateFormatter.string(from: myDate)
        return stringDate
    }
}
