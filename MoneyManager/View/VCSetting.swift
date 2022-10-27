//
//  VCSetting.swift
//  MoneyManager
//
//  Created by Roman on 16.01.2021.
//

import UIKit
import Foundation

protocol protocolVCSetting {
  func changeCategoryClosePopUpScreen2()
  func changeCategoryOpenPopUpScreen2(_ tag: Int)
  func tableViewScreen2Update(row: Int)
  func setCategoryInNewOperation(categoryUUID: UUID)

  // функции возврата
  func returnDelegateScreen2TableViewCellNote() -> protocolSettingTableVCNote

  // функции обновления newOperation
  func openAlertDatePicker()
  func startEditing()

  func setVCSetting(amount: Double, categoryUUID: UUID, date: Double, note: String, id: UUID)
  func returnNewOperation() -> Operation
  func returnScreen2MenuArray() -> [Screen2MenuData]
  func getUserData() -> User
}

struct Screen2MenuData {
  let name: String
  let text: String
}

class VCSetting: UIViewController {
  // MARK: - объявление аутлетов

  @IBOutlet var screen2SegmentControl: UISegmentedControl!
  @IBOutlet var tableViewScreen2: UITableView!
  @IBOutlet var screen2CurrencyDirection: UIButton!
  @IBOutlet var categoryChangeView: UIView!
  @IBOutlet var constraintCategoryChangeViewPoint: NSLayoutConstraint!
  @IBOutlet var constraintCategoryChangeViewHeight: NSLayoutConstraint!
  @IBOutlet var textFieldAmount: UITextField!
  @IBOutlet var labelScreen2Header: UILabel!

  // MARK: - делегаты, переменные
  var vcMainDelegate: protocolVCMain?
  var vcCategoryDelegate: VCCategory?
  var tableViewCellNoteDelegate: protocolSettingTableVCNote?
  var tableViewCellDateDelegate: protocolSettingTableVCDate?
  var vcSettingStatusEditing = false // показывает, создаётся ли новая операция, или редактируется предыдущая

  var tapOfChangeCategoryOpenPopUp: UITapGestureRecognizer?
  var tapOutsideTextViewToGoFromTextView: UITapGestureRecognizer?
  var keyboardHeight: CGFloat = 0 // хранит высоту клавиатуры

  var screen2MenuArray: [Screen2MenuData] = []
  var newOperation = Operation(amount: 0, category: nil, note: "", date: Date().timeIntervalSince1970, id: UUID())

  // MARK: - объекты
  let alertDatePicker = UIAlertController(title: "Select date", message: nil, preferredStyle: .actionSheet)
  let alertErrorAddNewOperation = UIAlertController(
    title: "Добавьте обязательные данные",
    message: nil,
    preferredStyle: .alert
  )
  let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
  let datePicker = UIDatePicker()

  // MARK: - переходы
  @IBAction func buttonToAddNewOperation(_ sender: Any) {
    var newOperation = returnNewOperation()
    if newOperation.category != nil && textFieldAmount.text != "0" {

      // set Amount
      print("2. screen2SegmentControl.selectedSegmentIndex= \(screen2SegmentControl.selectedSegmentIndex)")
      if screen2SegmentControl.selectedSegmentIndex == 0 {
        print("textFieldAmount.text= \(textFieldAmount.text as Optional)")
        newOperation.amount = Double(textFieldAmount.text ?? "0")!
      } else if screen2SegmentControl.selectedSegmentIndex == 1 {
        newOperation.amount = -Double(textFieldAmount.text ?? "0")!
      }

      // set Date
      if tableViewCellDateDelegate?.returnDateTextField().text == "Today" {
        newOperation.date = Date().timeIntervalSince1970
      } else {
        newOperation.date = datePicker.date.timeIntervalSince1970
      }

      // set Note
      if tableViewCellNoteDelegate?.returnNoteView().text! == "Placeholder" {
        newOperation.note = ""
      } else {
        newOperation.note = (tableViewCellNoteDelegate?.returnNoteView().text)!
      }

      print("newOperation.amount= \(newOperation.amount), newOperation.category= \(newOperation.category), newOperation.date= \(newOperation.date), newOperation.note= \(newOperation.note),")

      if vcSettingStatusEditing == true {
        vcMainDelegate?.updateOperations(
          amount: newOperation.amount,
          categoryUUID: newOperation.category!,
          note: newOperation.note,
          date: Date.init(timeIntervalSince1970: newOperation.date),
          idOfObject: newOperation.id
        )
      } else {
        vcMainDelegate?.addOperations(
          amount: newOperation.amount,
          categoryUUID: newOperation.category!,
          note: newOperation.note,
          date: Date.init(timeIntervalSince1970: newOperation.date)
        )
      }

      vcMainDelegate?.updateScreen()
      dismiss(animated: true, completion: nil)
    } else {
      self.present(alertErrorAddNewOperation, animated: true, completion: nil)
    }
  }

  @IBAction func buttonCloseSetting(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? VCCategory, segue.identifier == "segueToVCCategory" {
      vcCategoryDelegate = viewController
      viewController.vcSettingDelegate = self
      viewController.vcMainDelegate = vcMainDelegate
    }
  }


  // MARK: - клики
  @IBAction func textFieldAmountEditingDidBegin(_ sender: Any) {
    if textFieldAmount.textColor == UIColor.opaqueSeparator {
      textFieldAmount.text = nil
      switch screen2SegmentControl.selectedSegmentIndex {
      case 0:
        textFieldAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
      case 1:
        textFieldAmount.textColor = UIColor.red
      default:
        break
      }
    }
    print("func textViewDidBeginEditing")
  }

  @IBAction func textFieldAmountEditingDidEnd(_ sender: Any) {
    if let textFieldAmountText = textFieldAmount.text, textFieldAmountText.isEmpty {
      textFieldAmount.text = "0"
      textFieldAmount.textColor = UIColor.opaqueSeparator
    }
    textFieldAmount.resignFirstResponder()
    print("func textFieldAmountEditingDidEnd")
  }

  @IBAction func segmentControl(_ sender: Any) {
    textFieldAmount.endEditing(true)
    tableViewCellNoteDelegate?.tapOutsideNoteTextViewEditToHide()
    switch screen2SegmentControl.selectedSegmentIndex {
    case 0:
      screen2CurrencyDirection.setTitle("+$", for: .normal)
      screen2CurrencyDirection.setTitleColor(
        UIColor(
          cgColor: CGColor.init(
            srgbRed: 0.165,
            green: 0.671,
            blue: 0.014,
            alpha: 1
          )),
        for: .normal)
      textFieldAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    case 1:
      screen2CurrencyDirection.setTitle("-$", for: .normal)
      screen2CurrencyDirection.setTitleColor(UIColor.red, for: .normal)
      textFieldAmount.textColor = UIColor.red
    default:
      break
    }
  }

  // MARK: - viewWillAppear
  override func viewWillAppear(_ animated: Bool) {
    if vcSettingStatusEditing == true {
      startEditing()
    }

    super.viewWillAppear(animated)
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillDisappear),
        name: UIResponder.keyboardWillHideNotification,
        object: nil
      )
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillAppear),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
      )
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    menuArrayCalculate()
    self.view.insertSubview(self.blurView, belowSubview: self.categoryChangeView)
    self.blurView.backgroundColor = .clear
    self.blurView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.blurView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.blurView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
      self.blurView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
    ])
    self.blurView.isHidden = true

    self.view.layoutIfNeeded()
    // print("screen2MenuArray.count: \(screen2MenuArray.count)")

    self.tapOutsideTextViewToGoFromTextView = UITapGestureRecognizer(
      target: self,
      action: #selector(self.tapHandler(tap:))
    )
    self.view.addGestureRecognizer(self.tapOutsideTextViewToGoFromTextView!)

    createDatePicker()
    createAlertDatePicker()
    createAlertAddNewOperations()
  }

}
