//
//  VCScreen2+TableExtension.swift
//  SkillboxDiplomaStep1
//
//  Created by Roman on 28.04.2022.
//

import Foundation
import UIKit

extension VCScreen2: UITableViewDelegate, UITableViewDataSource {
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
      let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen2TableVCHeader
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory") as! Screen2TableVCCategory
      cell.delegateScreen2 = self
      cell.setTag(tag: indexPath.row)
      cell.startCell()
      self.delegateScreen2TableViewCellCategory = cell
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellDate") as! Screen2TableVCDate
      cell.delegateScreen2 = self
      cell.setTag(tag: indexPath.row)
      cell.startCell()
      self.delegateScreen2TableViewCellDate = cell
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote") as! Screen2TableVCNote
      cell.delegateScreen2 = self
      cell.setTag(tag: indexPath.row)
      cell.startCell()
      cell.textViewNotes.delegate = cell

      self.delegateScreen2TableViewCellNote = cell
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
