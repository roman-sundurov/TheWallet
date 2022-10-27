//
//  VCMainContainerGraph.swift
//  MoneyManager
//
//  Created by Roman on 01.05.2021.
//

import UIKit

protocol protocolVCGraph {
  func containerGraphUpdate()
  func setGraphIndicators(min: String, middle: String, max: String)
}

class VCGraph: UIViewController {
  // MARK: - объявление аутлетов

  @IBOutlet var graphView: GraphView!
  @IBOutlet var weeklyStackView: UIStackView!
  @IBOutlet var monthlyStackView: UIStackView!
  @IBOutlet var minIndicatorLabel: UILabel!
  @IBOutlet var middleIndicatorLabel: UILabel!
  @IBOutlet var maxIndicatorLabel: UILabel!


  // MARK: - делегаты и переменные
  var vcMainDelegate: VCMain?

  // MARK: - Functions
  func countFullPointsArray() {
    print("countFullPointsArray")
    let graphData = vcMainDelegate!.returnGraphData()
    print("graphData= \(graphData)")
    for data in graphData {
      print("graphData_n.cumulativeAmount= \(data.amount), graphData_n.date= \(data.date)")
    }

    var graphDataFinal: [GraphData] = []

    // Заполнение дней, в которых не было операций
    // Проверка наличия операция сегодня. Если нет проставляется 0.
    if !graphData.isEmpty {
      print("1111")
      if graphDataFinal.isEmpty {
        graphDataFinal.append(GraphData(newDate: Date(), newAmount: graphData.first!.amount))
      }

      // Проверка заполнения оставшихся дней. Если запись пуста - ставим 0.
      var x: Int = 1

      for amountOfDay in 1..<vcMainDelegate!.getUserData().daysForSorting {
        print("2222")

        if graphData.count >= x + 1 {
          print("3333")
          if vcMainDelegate!.returnDayOfDate(graphData[x].date) != vcMainDelegate!.returnDayOfDate(
            Calendar.current.date(
              byAdding: .day,
              value: -amountOfDay,
              to: Date()
            )!) {
            print("4444")
            graphDataFinal.append(GraphData(
              newDate: Calendar.current.date(
                byAdding: .day,
                value: -amountOfDay,
                to: Date()
              )!, newAmount: 0)
            )
          } else {
            print("5555")
            graphDataFinal.append(
              GraphData(
                newDate: Calendar.current.date(
                  byAdding: .day,
                  value: -amountOfDay,
                  to: Date())!,
                newAmount: graphData[x].amount
              )
            )
            x += 1
          }
        } else {
          print("5555")
          graphDataFinal.append(GraphData(
            newDate: Calendar.current.date(byAdding: .day, value: -amountOfDay, to: Date())!,
            newAmount: 0))
          x += 1
        }
      }
    }

    for data in graphDataFinal {
      print("n.cumulativeAmount= \(data.amount), n.date= \(data.date)")
    }

    graphView.setGraphPoints(data: graphDataFinal)
    graphView.setNeedsDisplay()
  }

  // MARK: - viewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()

    graphView.setDelegateScreen1ContainerGraph(deligate: self)

    graphView.layer.cornerRadius = 20
    graphView.layer.maskedCorners = [
      .layerMaxXMaxYCorner,
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner,
      .layerMinXMaxYCorner
    ]
    graphView.clipsToBounds = true
  }
}


extension VCGraph: protocolVCGraph {
  func setGraphIndicators(min: String, middle: String, max: String) {
    minIndicatorLabel.text = min
    middleIndicatorLabel.text = middle
    maxIndicatorLabel.text = max
  }


  func containerGraphUpdate() {
    countFullPointsArray()

    switch vcMainDelegate?.getUserData().daysForSorting {
    case 365:
      weeklyStackView.isHidden = true
      monthlyStackView.isHidden = false
    case 30:
      weeklyStackView.isHidden = true
      monthlyStackView.isHidden = true
    default:
      weeklyStackView.isHidden = false
      monthlyStackView.isHidden = true
    }
  }
}
