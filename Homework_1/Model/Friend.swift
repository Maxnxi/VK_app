//
//  Friend.swift
//  Homework_1
//
//  Created by Maksim on 22.02.2021.
//

import Foundation

class Friend {
    var firstName: String
    var lastName: String
    var avatarImg: String
    
    var fullName: String {
        let fstName = firstName
        let lstName = lastName
        return String("\(lstName) \(fstName) ")
    }
    
    init(firstName: String, lastName: String, avatarImg:String){
        self.firstName = firstName
        self.lastName = lastName
        self.avatarImg = avatarImg
    }
}


extension Friend {
    static let carl = Friend(firstName: "Carl", lastName: "Apple", avatarImg: "light1")
    static let nikolay = Friend(firstName: "Николай", lastName: "Zukerberg", avatarImg: "dark1")
    static let maksim = Friend(firstName: "Максим", lastName: "Иванов", avatarImg: "dark2")
    static let anna = Friend(firstName: "Анна", lastName: "Полякова", avatarImg: "dark3")
    static let friend1 = Friend(firstName: "John", lastName: "Grounf", avatarImg: "dark12")
    static let friend2 = Friend(firstName: "Bob", lastName: "Scientolog", avatarImg: "dark13")
    static let friend3 = Friend(firstName: "Todd", lastName: "Rubber", avatarImg: "dark5")
    static let friend4 = Friend(firstName: "Ван", lastName: "Тырдыкуль", avatarImg: "dark7")
    static let friend5 = Friend(firstName: "Чеша", lastName: "Йод", avatarImg: "light8")
    static let friend6 = Friend(firstName: "Цу", lastName: "Комар", avatarImg: "dark9")
    static let friend7 = Friend(firstName: "Зина", lastName: "Хомяк", avatarImg: "dark10")
    static let friend10 = Friend(firstName: "Kyle", lastName: "Rid", avatarImg: "dark14")
    static let friend20 = Friend(firstName: "Opel", lastName: "Youker", avatarImg: "dark15")
    static let friend30 = Friend(firstName: "Шарик", lastName: "Заза", avatarImg: "dark19")
    static let friend40 = Friend(firstName: "Ван", lastName: "Фарх", avatarImg: "dark18")
    static let friend50 = Friend(firstName: "Чеша", lastName: "Дорн", avatarImg: "light18")
    static let friend60 = Friend(firstName: "Цу", lastName: "Эльф", avatarImg: "light9")
    static let friend70 = Friend(firstName: "Зина", lastName: "Ябида", avatarImg: "dark17")
    
    static func dataLoad() -> [Friend] {
        return [ anna, maksim, nikolay, anna, maksim, nikolay, anna, maksim, nikolay, carl, carl, carl, friend1, friend2, friend3, friend4, friend5, friend6, friend7, friend10, friend20, friend30, friend40, friend50, friend60, friend70]
    }
    
    
    //MARK: -> сортровка массива друзей по имени в алфавитном порядке
    
//    static func sortArraybyLastName(arr:[Friend]) -> [Friend] {
//        let sortedArray = arr.sorted(by: { (obj1:Friend, obj2:Friend) -> Bool in
//            let obj1_firstName = obj1.lastName ?? ""
//            let obj2_firstName = obj2.lastName ?? ""
//            return (obj1_firstName.localizedCaseInsensitiveCompare(obj2_firstName) == ComparisonResult.orderedAscending)
//        })
//        print("\n sorted array: ", sortedArray)
//        
//        return sortedArray
//    }
    
    //MARK: -> промежуточная функция - извлечения заглавных букв из массива друзей
//    static func fullArrOfCapLetters(friends:[Friend]) -> [String] {
//         var array:[String] = []
//         var arrayOfNames:[String] = []
//
//         for index in 0..<friends.count {
//             arrayOfNames.append(friends[index].lastName ?? " ")
//         }
//         array = arrayOfNames.map {String($0.first!)}
//         return array
//     }
    
    //MARK: -> заполнение алфавитными буквами (из имен друзей)
//    static func sortLetters(letters:[String]) -> [String]{
//
//
//        var tmpArr:[String] = []
//
//
//        for index in 0..<letters.count {
//            if tmpArr.contains(letters[index]){
//                print("Буква Не добавлена,т.к. уже имеется!")
//
//            } else {
//                tmpArr.append(letters[index])
//                print("Буква добавлена!")
//            }
//        }
//        return tmpArr
//    }
    
    //MARK: -> расчет кол-ва друзей, чьи имена начинаются с одинаковой буквы
    
//    static func countFriendsOfOneLetter(friends: [Friend]) -> [Int] {
//        var tmpArrOfInt:[Int] = [0]
//
//        let tmpArr = Friend.dataLoad()
//        let tmpArr2 = Friend.sortArraybyLastName(arr: tmpArr)
//        let letters = Friend.fullArrOfCapLetters(friends: tmpArr2)
//
//        var counting = 1
//        for index in 0...8 {
//            if letters[index] == letters[index+1] {
//                counting += 1
//                tmpArrOfInt.insert(counting, at: index)
//            } else {
//
//                counting = 1
//            }
//
//        }
//
//
//        print(tmpArrOfInt)
//        return [3,3,3]
//
//
//    }
    
    
   
    
    
}
