//
//  VCOperation.swift
//  MoneyManager
//
//  Created by Roman on 17.04.2021.
//

import UIKit

protocol protocolVCOperation {
  func prepareForStart(id: UUID)
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
  var uuid: UUID?


  // MARK: - переходы


  @IBAction func buttonActionToEditOperation(_ sender: Any) {
    // vcMainDelegate?.editOperation(uuid: uuid!)
  }


  @IBAction func buttonActionToDeleteOperation(_ sender: Any) {
    // vcMainDelegate?.hideOperation()
    // vcMainDelegate?.deleteOperation(uuid: uuid!)
    // vcMainDelegate?.updateScreen()
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
  func prepareForStart(id: UUID) {
    uuid = id
    print("id= \(id)")
    let operation = UserRepository.shared.user?.operations.filter { $0.value.id == id }.first?.value

    // Отображения category
    labelCategory.text = vcMainDelegate?.getUserData().categories[operation!.category!.description]?.name

    // Отображения date
    let formatterPrint = DateFormatter()
    formatterPrint.dateFormat = "d MMMM YYYY"
    labelDate.text = formatterPrint.string(from: Date.init(timeIntervalSince1970: operation!.date))

    // Отображения amount
    if operation?.amount.truncatingRemainder(dividingBy: 1) == 0 {
      labelAmount.text = String(format: "%.0f", operation!.amount)
    } else {
      labelAmount.text = String(format: "%.2f", operation!.amount)
    }

    // Отображения currencyStatus
    if operation!.amount < 0 {
      labelAmount.textColor = UIColor.red
      currencyStatus.textColor = UIColor.red
    } else {
      labelAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
      currencyStatus.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    }

    // Отображение textViewNotes
    textViewNotes.text = operation?.note
  }
}
