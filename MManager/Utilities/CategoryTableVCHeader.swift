//  TableViewCellHeaderScreen2Container.swift
//  MoneyManager
//
//  Created by Roman on 23.01.2021.
//

import UIKit

protocol protocolCategoryTableVCHeader {
  func buttonOptionsSetColor(color: UIColor)
}

class CategoryTableVCHeader: UITableViewCell {
  @IBOutlet var buttonOptions: UIButton!

  @IBAction func buttonOptionsAction(_ sender: Any) {
    delegateScreen2Container?.screen2ContainerNewCategorySwicher()
  }

  var delegateScreen2Container: protocolVCCategory?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension CategoryTableVCHeader: protocolCategoryTableVCHeader {
  func buttonOptionsSetColor(color: UIColor) {
    buttonOptions.tintColor = color
  }
}
