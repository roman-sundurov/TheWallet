//
//  VCScreen2+TableExtension.swift
//  MoneyManager
//
//  Created by Roman on 28.04.2022.
//

import Foundation
import UIKit

extension VCSetting: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("indexPath.row= \(indexPath.row)")
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! UITableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory") as! SettingTableVCCategory
      cell.vcSettingDelegate = self
      cell.prepareCell(indexRow: indexPath.row)
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellDate") as! SettingTableVCDate
      cell.vcSettingDelegate = self
      cell.startCell(indexRow: indexPath.row)
      self.tableViewCellDateDelegate = cell
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote") as! SettingTableVCNote
      cell.vcSettingDelegate = self
      cell.startCell(indexRow: indexPath.row)
      cell.textViewNotes.delegate = cell

      self.tableViewCellNoteDelegate = cell
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
