//
//  VCMaingOperation.swift
//  MoneyManager
//
//  Created by Roman on 17.04.2021.
//

import UIKit

protocol protocolScreen1ContainerOperation {
  func startCell(tag: Int)
}

class VCMaingOperation: UIViewController {
  // MARK: - аутлеты

  @IBOutlet var labelCategory: UILabel!
  @IBOutlet var labelDate: UILabel!
  @IBOutlet var labelAmount: UILabel!
  @IBOutlet var currencyStatus: UILabel!
  @IBOutlet var textViewNotes: UITextView!
  @IBOutlet var viewRightParth: UIView!
  @IBOutlet var buttonToEditOperation: UIButton!
  @IBOutlet var buttonToDeleteOperation: UIButton!
  @IBOutlet var viewLogoCategory: UIView!


  // MARK: - делегаты и переменные

  var vcMainDelegate: protocolVCMain?
  var newTableDataArray: [Operation] = []
  var specCellTag: Int = 0
  var specVar: Int = 0


  // MARK: - переходы


  @IBAction func buttonActionToEditOperation(_ sender: Any) {
    vcMainDelegate?.editOperation(tag: specVar)
  }


  @IBAction func buttonActionToDeleteOperation(_ sender: Any) {
    vcMainDelegate?.hideOperation()
    vmMain.shared.deleteOperationInRealm(tag: specVar)
    vcMainDelegate?.updateScreen()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    textViewNotes.layer.cornerRadius = 10
    viewRightParth.layer.cornerRadius = 10
    buttonToEditOperation.layer.cornerRadius = 10
    buttonToDeleteOperation.layer.cornerRadius = 10
    viewLogoCategory.layer.cornerRadius = 10
  }
}


extension VCMaingOperation: protocolScreen1ContainerOperation {
  func startCell(tag: Int) {
    print(tag)
    print(vmMain.shared.returnArrayForIncrease()[tag])

    specCellTag = tag
    specVar = specCellTag - vmMain.shared.returnArrayForIncrease()[specCellTag]

    // Отображения category
    labelCategory.text = vmMain.shared.returnDataArrayOfOperations()[specVar].category

    // Отображения date
    let formatterPrint = DateFormatter()
    formatterPrint.dateFormat = "d MMMM YYYY"
    labelDate.text = formatterPrint.string(from: vmMain.shared.returnDataArrayOfOperations()[specVar].date)

    // Отображения amount
    if vmMain.shared.returnDataArrayOfOperations()[specVar].amount.truncatingRemainder(dividingBy: 1) == 0 {
      labelAmount.text = String(format: "%.0f", vmMain.shared.returnDataArrayOfOperations()[specVar].amount)
    } else {
      labelAmount.text = String(format: "%.2f", vmMain.shared.returnDataArrayOfOperations()[specVar].amount)
    }

    // Отображения currencyStatus
    if vmMain.shared.returnDataArrayOfOperations()[specVar].amount < 0 {
      labelAmount.textColor = UIColor.red
      currencyStatus.textColor = UIColor.red
    } else {
      labelAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
      currencyStatus.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    }

    // Отображение textViewNotes
    textViewNotes.text = vmMain.shared.returnDataArrayOfOperations()[specVar].note
  }
}
