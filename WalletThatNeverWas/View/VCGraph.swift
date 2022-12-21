//
//  VCMainContainerGraph.swift
//  MoneyManager
//
//  Created by Roman on 01.05.2021.
//

import UIKit
import AAInfographics

protocol ProtocolVCGraph {
  func dataUpdate()
}

class VCGraph: UIViewController {
  // MARK: - outlets
  @IBOutlet var graphView: UIView!

  // MARK: - delegates and variables
  var vcMainDelegate: VCMain?
  let calendar = Calendar.current
  var firstDate: Date?
  var secondDate: Date?

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func calculateDateArray() -> [Date] {
    var dateArray: [Date] = []
    let calendar = Calendar.current
    let date = Date()
    for day in 0...31 {
      let dateComponent = DateComponents(day: -day)
      firstDate = calendar.dateInterval(of: .day, for: date)?.start
      secondDate = calendar.date(byAdding: dateComponent, to: firstDate!)
      if day == 0 {
        dateArray.append(firstDate!)
      } else {
        dateArray.append(secondDate!)
      }
      let dateComponentTemp = DateComponents(month: -1)
      let freshHoldDate = calendar.date(byAdding: dateComponentTemp, to: date)
      if secondDate!.timeIntervalSince1970 < freshHoldDate!.timeIntervalSince1970 {
        break
      }
    }
    return dateArray
  }

  func calculateCumulativeAmount(dateArray: [Date]) -> [GraphData] {
    var cumulativeArray: [GraphData] = []
    var cumulativeAmount: Double = 0
    let operations = UserRepository.shared.user!.operations
    var firstDate = Date()
    var secondDate = Date()
    for day in 0..<dateArray.count {
      secondDate = dateArray[day]
      if day != 0 {
        firstDate = dateArray[day - 1]
      }
      for oper in UserRepository.shared.user!.operations {
        if oper.value.date >= secondDate.timeIntervalSince1970 && oper.value.date < firstDate.timeIntervalSince1970 {
          print("oper.value.amount \(oper.value.date )= \(oper.value.amount)")
          cumulativeAmount += oper.value.amount
          print("cumulativeAmount= \(cumulativeAmount)")
        }
      }
      cumulativeArray.append(GraphData(date: dateArray[day], amount: cumulativeAmount))
    }
    return cumulativeArray
  }
}

extension VCGraph: ProtocolVCGraph {
  func dataUpdate() {
    var dateArray = calculateDateArray()
    let cumulativeGraphDataArray = calculateCumulativeAmount(dateArray: dateArray)
    var cumulativeArray: [Double] = []
    var numberOfDayArray: [String] = []
    for item in cumulativeGraphDataArray {
      let components = calendar.dateComponents([.day], from: item.date)
      let digitDay = components.day
      cumulativeArray.append(item.amount)
      numberOfDayArray.append(digitDay!.description)
    }
    print("cumulativeArray= \(cumulativeArray)")
    print("numberOfDayArray= \(numberOfDayArray)")
    graphView.layer.cornerRadius = 20
    graphView.layer.maskedCorners = [
      .layerMaxXMaxYCorner,
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner,
      .layerMinXMaxYCorner
    ]
    graphView.clipsToBounds = true
    let aaChartView = AAChartView()
    aaChartView.frame = CGRect(x: 0, y: 0, width: graphView.frame.width, height: graphView.frame.height)
    graphView.addSubview(aaChartView)
    let aaChartModel = AAChartModel()
      .chartType(.area) // Can be any of the chart types listed under `AAChartType`.
      .animationType(.bounce)
      // .title("TITLE")//The chart title
      // .subtitle("subtitle")//The chart subtitle
      .dataLabelsEnabled(false) // enable or disable the data labels. Defaults to false
      .tooltipValueSuffix("$")// the value suffix of the chart tooltip
      .categories(numberOfDayArray)
      .colorsTheme(["#6FC3C6", "#fe117c", "#ffc069", "#06caf4", "#7dffc0"])
      .series([
        AASeriesElement()
          .name("Balance")
          .data(cumulativeArray)
      ])
    aaChartView.aa_drawChartWithChartModel(aaChartModel)
  }
}
