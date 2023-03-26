//
//  VCScreen2+TableExtension.swift
//  MoneyManager
//
//  Created by Roman on 28.04.2022.
//

import Foundation
import UIKit

extension VCSetting: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension VCSetting: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.row= \(indexPath.row)")
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifier.header.rawValue) {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            } else {
                vcMainDelegate?.showAlert(message: "cell VCSetting_Header not found")
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifier.cellCategory.rawValue) as? SettingTableVCCategory {
                cell.vcSettingDelegate = self
                cell.prepareCell(indexRow: indexPath.row)
                return cell
            } else {
                vcMainDelegate?.showAlert(message: "cell SettingTableVCCategory not found")
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifier.cellDate.rawValue) as? SettingTableVCDate {
                cell.vcSettingDelegate = self
                cell.startCell(indexRow: indexPath.row)
                self.tableViewCellDateDelegate = cell
                return cell
            } else {
                vcMainDelegate?.showAlert(message: "cell SettingTableVCDate not found")
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifier.cellNote.rawValue) as? SettingTableVCNote {
                cell.vcSettingDelegate = self
                cell.startCell(indexRow: indexPath.row)
                cell.textViewNotes.delegate = cell
                self.tableViewCellNoteDelegate = cell
                return cell
            } else {
                vcMainDelegate?.showAlert(message: "cell SettingTableVCNote not found")
            }
        }
        return UITableViewCell()
    }
}
