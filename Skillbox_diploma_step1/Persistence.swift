//
//  Persistence.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 26.01.2021.
//

import Foundation
import RealmSwift

class ListOfOperations: Object{
    @objc dynamic var isIncome: Bool = true
    @objc dynamic var category: String = ""
    @objc dynamic var account: String = ""
    @objc dynamic var note: String = ""
}

private let realm = try! Realm()

func addOperations(isIncome: Bool, category: String, account: String, note: String){
    let operation = ListOfOperations()
    operation.isIncome = isIncome
    operation.category = category
    operation.account = account
    operation.note = note
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
