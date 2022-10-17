//
//  Screen1TableViewCellCategory.swift
//  MoneyManager
//
//  Created by Roman on 26.01.2021.
//

import UIKit

class Screen1TableVCOperation: UITableViewCell {
  @IBOutlet var viewPictureOfCategory: UIView!
  @IBOutlet var labelCategory: UILabel!
  @IBOutlet var labelAmount: UILabel!
  @IBOutlet var currencyStatus: UILabel!

  var delegateScreen1: protocolVCMain?
  var specCellTag: Int = 0

// Анимация
  @objc func actionsOperationsOpenPopUpScreen1(_ tag: Int) {
    delegateScreen1?.showOperation(specCellTag)
    print("ChangeCategory from Screen2")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func startCell() {
    print("Simple Cell: ---")
    let specVar: Int = specCellTag - vmMain.shared.returnArrayForIncrease()[specCellTag]
    labelCategory.text = vmMain.shared.returnDataArrayOfOperations()[specVar].category

    if vmMain.shared.returnDataArrayOfOperations()[specVar].amount.truncatingRemainder(dividingBy: 1) == 0 {
      labelAmount.text = String(format: "%.0f", vmMain.shared.returnDataArrayOfOperations()[specVar].amount)
    } else {
      labelAmount.text = String(format: "%.2f", vmMain.shared.returnDataArrayOfOperations()[specVar].amount)
    }
    if vmMain.shared.returnDataArrayOfOperations()[specVar].amount < 0 {
      labelAmount.textColor = UIColor.init(named: "InterfaceColorRed")
      currencyStatus.textColor = UIColor.init(named: "InterfaceColorRed")
    } else {
      labelAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
      currencyStatus.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    }
    let gesture = UITapGestureRecognizer(target: self, action: #selector(showOperation(_:)))
    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(gesture)
  }

  func setTag(tag: Int) {
    specCellTag = tag
  }
}
