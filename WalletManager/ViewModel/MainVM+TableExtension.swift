//
//  VCMain+TableExtension.swift
//  MoneyManager
//
//  Created by Roman on 27.04.2022.
//

import Foundation
import UIKit

extension VCMain {
  func configureDataSource() {
    datasource = MyDataSource(tableView: tableView) { tableview, indexpath, model -> UITableViewCell? in
      let cell = tableview.dequeueReusableCell(withIdentifier: "operation", for: indexpath) as? MainTableVCOperation
      if model.amount.truncatingRemainder(dividingBy: 1) == 0 {
        cell?.labelAmount.text = String(format: "%.0f", model.amount)
      } else {
        cell?.labelAmount.text = String(format: "%.2f", model.amount)
      }
      if let category = self.getUserData().categories[model.category!.description] {
        cell?.labelCategory.text = category.name
      } else {
        cell?.labelCategory.text = "Category not found"
      }
      // print("model.category.description= \(model.category.description)")
      // print("categoryname= \(self.getUserData().categories[model.category.description]?.name)")
      if model.amount < 0 {
        cell?.labelAmount.textColor = UIColor.init(named: "InterfaceColorRed")
        cell?.currencyStatus.textColor = UIColor.init(named: "InterfaceColorRed")
      } else {
        cell?.labelAmount.textColor = UIColor(
          cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1)
        )
        cell?.currencyStatus.textColor = UIColor(
          cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1)
        )
      }
      cell?.id = model.id
      cell?.vcMainDelegate = self
      return cell
    }
  }

  func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<String, Operation>()
    let (sections, sectionsSource) = calculateSource()
    snapshot.appendSections(sections)
    for section in sections {
      snapshot.appendItems(sectionsSource[section]!, toSection: section)
    }
    datasource!.apply(snapshot, animatingDifferences: animatingDifferences)
  }

  func calculateSource() -> ([String], [String: [Operation]]) {
    var sectionsDouble: [Double] = []
    var sectionsTemp: [String] = []
    var operationForGraph: [Operation] = []
    if let userData = userRepository.user {
      let freshHold = Date().timeIntervalSince1970 - Double(86400 * userData.daysForSorting)
      for oper in userData.operations where oper.value.date >= freshHold {
        operationForGraph.append(oper.value)
        sectionsDouble.append(oper.value.date)
        sectionsDouble.sort { $0 > $1 }
      }
      for double in sectionsDouble {
        if !sectionsTemp.contains(dateFormatter.string(from: Date.init(timeIntervalSince1970: double))) {
          sectionsTemp.append(dateFormatter.string(from: Date.init(timeIntervalSince1970: double)))
        } else {
          sectionsTemp.append("")
        }
      }
      UserRepository.shared.mainDiffableSections = []
      UserRepository.shared.mainDiffableSectionsSource = [:]
      for item in sectionsTemp where !item.isEmpty {
        UserRepository.shared.mainDiffableSections.append(item)
      }
      for oper in userData.operations where oper.value.date >= freshHold {
        let newStringDate = dateFormatter.string(from: Date.init(timeIntervalSince1970: oper.value.date))
        if let item = UserRepository.shared.mainDiffableSectionsSource[newStringDate] {
          UserRepository.shared.mainDiffableSectionsSource[newStringDate] = item + [oper.value]
        } else {
          UserRepository.shared.mainDiffableSectionsSource[newStringDate] = [oper.value]
        }
      }
      print("sectionsSource= \(UserRepository.shared.mainDiffableSectionsSource)")
      print("sections= \(UserRepository.shared.mainDiffableSections)")
      return (UserRepository.shared.mainDiffableSections, UserRepository.shared.mainDiffableSectionsSource)
    } else {
      return ([], [:])
    }
  }
}

class MyDataSource: UITableViewDiffableDataSource<String, Operation> {
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return UserRepository.shared.mainDiffableSections[section]
  }
}
