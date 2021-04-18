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
    @objc dynamic var lastID: Int = -1
//    @objc dynamic var operations: ListOfOperations?
}

class ListOfOperations: Object{
    @objc dynamic var amount: Double = 0
    @objc dynamic var category: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var date: Date = Date.init(timeIntervalSince1970: TimeInterval(0))
    @objc dynamic var id: Int = 0
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
        operation.id = realm.objects(Person.self).first!.lastID + 1
        try! realm.write{
            realm.add(operation)
            realm.objects(Person.self).first!.lastID = operation.id
        }
    }
        
    func getRealmData() -> Results<ListOfOperations>{
        let allOperations = realm.objects(ListOfOperations.self)
        return allOperations
    }

    func deleteRealmData(idOfObject: Int){
        let particularOperations = realm.objects(ListOfOperations.self).filter("id == \(idOfObject)")
//        var index: Int? = allOperations.index(of: particularObject) ?? nil
        print("idOfObject for delete= \(idOfObject)")
        try! realm.write{
            realm.delete(particularOperations)
        }
    }
    
    //MARK: - личные данные
    
//    func updateLastID() -> Int {
//        return realm.objects(Person.self).first!.lastID
//    }
    
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
