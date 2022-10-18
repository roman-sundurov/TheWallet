//
//  VCMain+TableExtension.swift
//  MoneyManager
//
//  Created by Roman on 27.04.2022.
//

import Foundation
import UIKit

extension VCMain: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("ViewModelScreen1.shared.tableNumberOfRowsInSection()= \(tableNumberOfRowsInSection())")
    return tableNumberOfRowsInSection()
    // return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("indexPath.row= \(indexPath.row)")
    let arrayForIncrease = returnArrayForIncrease()
    if userData!.operations.isEmpty {
      let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! ViewCellData
      cell.vcMainDelegate = self
      cell.startCellEmpty()
      return cell
    } else {
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! ViewCellData
        cell.vcMainDelegate = self
        cell.setTag(tag: indexPath.row)
        cell.startCell()
        return cell
      } else if arrayForIncrease[indexPath.row] != arrayForIncrease[indexPath.row - 1] {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! ViewCellData
        cell.vcMainDelegate = self
        cell.setTag(tag: indexPath.row)
        cell.startCell2()
        return cell
      } else if indexPath.row == arrayForIncrease.count {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! ViewCellData
        cell.labelHeaderDate.isHidden = true
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "operation") as! ViewCellOperation
        cell.vcMainDelegate = self
        cell.setTag(tag: indexPath.row)
        cell.startCell()
        return cell
      }
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
