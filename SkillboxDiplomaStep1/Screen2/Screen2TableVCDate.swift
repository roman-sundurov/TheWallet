//
//  Screen2TableViewCellDate.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 06.03.2021.
//

import UIKit

protocol protocolScreen2TableVCDateDelegate{
  func returnDateTextField() -> UILabel
}


class Screen2TableVCDate: UITableViewCell {
  @IBOutlet var labelDate: UILabel!
  @IBOutlet var labelSelectDate: UILabel!
  @IBOutlet var buttonSelectDate: UIButton!

  // MARK: - делегаты и переменные
  var delegateScreen2: protocolScreen2Delegate?
  var specCellTag: Int = 0

  // MARK: - переходы

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }


  @objc func startEditing() {
    delegateScreen2?.openAlertDatePicker()
    print("startEditing")
  }


  func startCell() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none

    if delegateScreen2?.returnNewOperation().date != Date.init(timeIntervalSince1970: TimeInterval(0)) {
      labelSelectDate.text = dateFormatter.string(from: delegateScreen2!.returnNewOperation().date)
      labelSelectDate.textColor = .black
    } else {
      labelSelectDate.text = delegateScreen2?.returnScreen2MenuArray()[specCellTag].text
    }

    // textFieldSelectDate.tintColor = UIColor.clear //делает курсор бесцветным, но не убирает его
    labelDate.text = delegateScreen2?.returnScreen2MenuArray()[specCellTag].name
    self.isUserInteractionEnabled = true

    let gesture = UITapGestureRecognizer(target: self, action: #selector(startEditing))
    self.addGestureRecognizer(gesture)
  }

  func setTag(tag: Int) {
    specCellTag = tag
  }
}


extension Screen2TableVCDate: protocolScreen2TableVCDateDelegate {
  func returnDateTextField() -> UILabel {
    print("textViewDeselect")
    return labelSelectDate
  }
}