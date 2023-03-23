//
//  SettingTableVCDate.swift
//  MoneyManager
//
//  Created by Roman on 06.03.2021.
//

import UIKit

protocol ProtocolSettingTableVCDate {
    func returnDateTextField() -> UILabel
}

final class SettingTableVCDate: UITableViewCell {
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelSelectDate: UILabel!
    @IBOutlet var buttonSelectDate: UIButton!

        // MARK: - delegates and variables
    var vcSettingDelegate: ProtocolVCSetting?
    var indexRow: Int = 0

        // MARK: - transitions

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func startEditing() {
        vcSettingDelegate?.openAlertDatePicker()
        print("startEditing")
    }

    func startCell(indexRow: Int) {
        self.indexRow = indexRow
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        if vcSettingDelegate!.returnNewOperation().date != 0 {
            labelSelectDate.text = dateFormatter.string(
                from: Date.init(timeIntervalSince1970: vcSettingDelegate!.returnNewOperation().date)
            )
            labelSelectDate.textColor = .black
        } else {
            labelSelectDate.text = vcSettingDelegate!.getSettingMenuArray()[indexRow].text
        }

            // textFieldSelectDate.tintColor = UIColor.clear // makes the cursor colorless, but does not remove it
        labelDate.text = vcSettingDelegate!.getSettingMenuArray()[indexRow].name
        self.isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        self.addGestureRecognizer(gesture)
    }

    func setTag(tag: Int) {
        indexRow = tag
    }
}

extension SettingTableVCDate: ProtocolSettingTableVCDate {
    func returnDateTextField() -> UILabel {
        print("textViewDeselect")
        return labelSelectDate
    }
}
