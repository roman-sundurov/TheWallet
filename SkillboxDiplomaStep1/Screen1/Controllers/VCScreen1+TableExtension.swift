//
//  VCScreen1+TableExtension.swift
//  SkillboxDiplomaStep1
//
//  Created by Roman on 27.04.2022.
//

import Foundation
import UIKit

extension VCScreen1: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ViewModelScreen1.shared.tableNumberOfRowsInSection()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let arrayForIncrease = ViewModelScreen1.shared.returnArrayForIncrease()
    if ViewModelScreen1.shared.returnDataArrayOfOperations().isEmpty {
      let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableVCHeader
      cell.delegateScreen1 = self
      cell.startCellEmpty()
      return cell
    } else {
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableVCHeader
        cell.delegateScreen1 = self
        cell.setTag(tag: indexPath.row)
        cell.startCell()
        return cell
      } else if arrayForIncrease[indexPath.row] != arrayForIncrease[indexPath.row - 1] {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableVCHeader
        cell.delegateScreen1 = self
        cell.setTag(tag: indexPath.row)
        cell.startCell2()
        return cell
      } else if indexPath.row == arrayForIncrease.count {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableVCHeader
        cell.labelHeaderDate.isHidden = true
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "operation") as! Screen1TableVCOperation
        cell.delegateScreen1 = self
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

  func tableViewReloadData() {
    self.tableViewScreen1.reloadData()
  }
}
