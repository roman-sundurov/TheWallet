//
//  Persistence.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 26.01.2021.
//

import Foundation
import RealmSwift

class ListOfOperations: Object{
    @objc dynamic var amount: Double = 0
    @objc dynamic var category: String = ""
    @objc dynamic var account: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var date: Date = Date.init()
}



class Persistence{
    
    static let shared = Persistence()
    private let realm = try! Realm()

    func addOperations(amount: Double, category: String, account: String, note: String, date: Date){
        let operation = ListOfOperations()
        operation.category = category
        operation.account = account
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
}
