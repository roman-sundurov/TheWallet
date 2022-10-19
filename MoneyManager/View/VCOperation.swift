//
//  VCOperation.swift
//  MoneyManager
//
//  Created by Roman on 17.04.2021.
//

import UIKit

protocol protocolVCOperation {
  func startCell(tag: Int)
}

class VCOperation: UIViewController {
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
  var specVar: UUID?


  // MARK: - переходы


  @IBAction func buttonActionToEditOperation(_ sender: Any) {
    vcMainDelegate?.editOperation(tag: specVar!)
  }


  @IBAction func buttonActionToDeleteOperation(_ sender: Any) {
    vcMainDelegate?.hideOperation()
    vcMainDelegate?.deleteOperation(idOfObject: specVar!)
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


extension VCOperation: protocolVCOperation {
  func startCell(tag: Int) {
    // print(tag)
    // print(vcMainDelegate!.returnArrayForIncrease()[tag])
    // 
    // specCellTag = tag
    // specVar = specCellTag - vcMainDelegate!.returnArrayForIncrease()[specCellTag]
    // 
    // // Отображения category
    // labelCategory.text = vcMainDelegate!.getUserData().operations[specVar].category
    // 
    // // Отображения date
    // let formatterPrint = DateFormatter()
    // formatterPrint.dateFormat = "d MMMM YYYY"
    // labelDate.text = formatterPrint.string(from: vcMainDelegate!.getUserData().operations[specVar].date)
    // 
    // // Отображения amount
    // if vmMain.shared.returnDataArrayOfOperations()[specVar].amount.truncatingRemainder(dividingBy: 1) == 0 {
    //   labelAmount.text = String(format: "%.0f", vcMainDelegate!.getUserData().operations[specVar].amount)
    // } else {
    //   labelAmount.text = String(format: "%.2f", vcMainDelegate!.getUserData().operations[specVar].amount)
    // }
    // 
    // // Отображения currencyStatus
    // if vcMainDelegate!.getUserData().operations[specVar].amount < 0 {
    //   labelAmount.textColor = UIColor.red
    //   currencyStatus.textColor = UIColor.red
    // } else {
    //   labelAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    //   currencyStatus.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    // }
    // 
    // // Отображение textViewNotes
    // textViewNotes.text = vcMainDelegate!.getUserData().operations[specVar].note
  }
}
