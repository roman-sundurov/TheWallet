//  TableViewCellHeaderScreen2Container.swift
//  MoneyManager
//
//  Created by Roman on 23.01.2021.
//

import UIKit

protocol protocolScreen2ContainerTableVClHeader {
  func buttonOptionsSetColor(color: UIColor)
}

class Screen2ContainerTableVCHeader: UITableViewCell {
  // MARK: - аутлеты

  @IBOutlet var buttonOptions: UIButton!

  // MARK: - делегаты и переменные

  var delegateScreen2Container: protocolScreen2ContainerDelegate?

  // MARK: - переходы

  @IBAction func buttonOptionsAction(_ sender: Any) {
    delegateScreen2Container?.screen2ContainerNewCategorySwicher()
  }


  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension Screen2ContainerTableVCHeader: protocolScreen2ContainerTableVClHeader {
  func buttonOptionsSetColor(color: UIColor) {
    buttonOptions.tintColor = color
  }
}
