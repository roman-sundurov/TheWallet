//
//  vmMain.swift
//  MoneyManager
//
//  Created by Roman on 27.04.2022.
//

import Foundation

extension VCMain {

  func returnArrayForIncrease() -> [Int] {
    return arrayForIncrease
  }

  func returnDayOfDate(_ dateInternal: Date) -> String {
    let formatterPrint = DateFormatter()
    formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
    switch User.shared.daysForSorting {
    case 365:
      formatterPrint.dateFormat = "MMMM YYYY"
    default:
      formatterPrint.dateFormat = "d MMMM YYYY"
    }
    return formatterPrint.string(from: dateInternal)
  }


  // MARK: - value set functions
  func setDaysForSorting(newValue: Int) {
    UserRepository.shared.updateDaysForSorting(daysForSorting: newValue)
    daysForSorting = newValue
  }


  // MARK: - data calculating
  func graphDataArrayCalculating(dataArrayOfOperationsInternal: [Operation]) {
    // Данные для передачи в график
    // Cохраняет суммы операций по дням некуммулятивно
    graphDataArray = []
    for data in dataArrayOfOperationsInternal {
      if graphDataArray.isEmpty {
        graphDataArray.append(GraphData.init(newDate: data.date, newAmount: data.amount))
      } else {
        for x in graphDataArray {
          if returnDayOfDate(x.date) == returnDayOfDate(data.date) {
            graphDataArray.first { returnDayOfDate($0.date) == returnDayOfDate(data.date) }?
              .amount += data.amount
            // graphDataArray.filter { returnDayOfDate($0.date) == returnDayOfDate(data.date) }
            //   .first?.amount += data.amount
          }
        }
        if (graphDataArray.filter { returnDayOfDate($0.date) == returnDayOfDate(data.date) }).isEmpty {
          graphDataArray.append(GraphData.init(newDate: data.date, newAmount: data.amount))
        }
      }
    }
    print("dataArrayOfOperations before filter: \(dataArrayOfOperations)")
    graphDataArray.sort { $0.date > $1.date }
    print("graphDataArray after sort: \(graphDataArray)")
  }

  func returnGraphData() -> [GraphData] {
    return graphDataArray
  }


  // MARK: - таблица списка операций
  func tableNumberOfRowsInSection() -> Int {
    if dataArrayOfOperations.isEmpty { return 1 }
    arrayForIncrease = [1]
    var previousDay: Int = 0
    var counter: Int = 0

    for x in dataArrayOfOperations {
      if Calendar.current.component(.day, from: x.date) != previousDay {
        if counter != 0 {
          // Расчёт множителя, который компенсирует наличие header'ов в таблице
          arrayForIncrease.append(arrayForIncrease.last!)
          arrayForIncrease.append(arrayForIncrease.last! + 1)
        }
        previousDay = Calendar.current.component(.day, from: x.date)
      } else {
        arrayForIncrease.append(arrayForIncrease.last!)
      }
      counter += 1
    }
    arrayForIncrease.append(arrayForIncrease.last!)
    graphDataArrayCalculating(dataArrayOfOperationsInternal: dataArrayOfOperations)
    return arrayForIncrease.count
  }

  // MARK: - Обновление сортировки
  func screen1TableUpdateSorting() {
    let newTime = Date() - TimeInterval.init(86400 * returnDaysForSorting())
    dataArrayOfOperations = dataArrayOfOperationsOriginal
    dataArrayOfOperations.sort { $0.date > $1.date }
  
    graphDataArray = graphDataArray
      .sorted { $0.date > $1.date }
      .filter { $0.date >= newTime }
    print("graphDataArray when sort: \(graphDataArray)")
  
    let temporarilyDate = dataArrayOfOperations.filter { $0.date >= newTime }
    dataArrayOfOperations = temporarilyDate
  }
}
