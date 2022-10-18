//
//  Screen1TableViewCellCategory.swift
//  MoneyManager
//
//  Created by Roman on 26.01.2021.
//

import UIKit

class MainTableVCOperation: UITableViewCell {
  @IBOutlet var viewPictureOfCategory: UIView!
  @IBOutlet var labelCategory: UILabel!
  @IBOutlet var labelAmount: UILabel!
  @IBOutlet var currencyStatus: UILabel!

  var vcMainDelegate: protocolVCMain?
  var specCellTag: Int = 0

// Анимация
  @objc func showOperation(_ tag: Int) {
    vcMainDelegate?.showOperation(specCellTag)
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
    let specVar: Int = specCellTag - vcMainDelegate!.returnArrayForIncrease()[specCellTag]
    labelCategory.text = vcMainDelegate!.getUserData().operations[specVar].category

    if vcMainDelegate!.getUserData().operations[specVar].amount.truncatingRemainder(dividingBy: 1) == 0 {
      labelAmount.text = String(format: "%.0f", vcMainDelegate!.getUserData().operations[specVar].amount)
    } else {
      labelAmount.text = String(format: "%.2f", vcMainDelegate!.getUserData().operations[specVar].amount)
    }
    if vcMainDelegate!.getUserData().operations[specVar].amount < 0 {
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
