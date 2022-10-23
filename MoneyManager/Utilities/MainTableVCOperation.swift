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
    // vcMainDelegate?.showOperation(specCellTag)
    print("ChangeCategory from Screen2")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    let gesture = UITapGestureRecognizer(target: self, action: #selector(showOperation(_:)))
    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(gesture)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func startCell() {
    print("Simple Cell: ---")

  }

  // func setTag(tag: Int) {
  //   specCellTag = tag
  // }
}
