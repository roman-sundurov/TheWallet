//
//  Persistence.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 26.01.2021.
//

import Foundation
import RealmSwift

class Person: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var daysForSorting: Int = 0
}

class ListOfOperations: Object{
    @objc dynamic var amount: Double = 0
    @objc dynamic var category: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var date: Date = Date.init(timeIntervalSince1970: TimeInterval(0))
}

class Persistence{
    
    static let shared = Persistence()
    private let realm = try! Realm()
    
    //MARK: - торговые операции

    func addOperations(amount: Double, category: String, note: String, date: Date){
        let operation = ListOfOperations()
        operation.category = category
        operation.note = note
        operation.amount = amount
        operation.date = date
        try! realm.write{
            realm.add(operation)
        }
    }
        
    func getRealmData() -> Results<ListOfOperations>{
        let allOperations = realm.objects(ListOfOperations.self)
        return allOperations
    }

    func deleteRealmData(tag: Int){
        let allOperations = realm.objects(ListOfOperations.self)
        try! realm.write{
            realm.delete(allOperations[tag])
        }
    }
    
    //MARK: - личные данные
    
    func updateDaysForSorting(daysForSorting: Int){
        let person = realm.objects(Person.self).first
        
        try! realm.write{
            person!.daysForSorting = daysForSorting
        }
    }
        
    func getDaysForSorting() -> Int{
        print("old person returned")
        let person = realm.objects(Person.self).first
        if person?.daysForSorting != nil {
            return person!.daysForSorting
        }
        else{
            print("newPerson added")
            let newPerson = Person()
            newPerson.daysForSorting = 30
            try! realm.write{
                realm.add(newPerson)
            }
            return newPerson.daysForSorting
        }
    }
    
}
