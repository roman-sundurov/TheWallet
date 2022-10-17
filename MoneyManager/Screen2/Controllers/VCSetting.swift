//
//  VCSetting.swift
//  MoneyManager
//
//  Created by Roman on 16.01.2021.
//

import UIKit

protocol protocolVCSetting {
  func changeCategoryClosePopUpScreen2()
  func changeCategoryOpenPopUpScreen2(_ tag: Int)
  func tableViewScreen2Update(row: Int)

  // функции возврата
  func returnDelegateScreen2TableViewCellNote() -> protocolScreen2TableVCNoteDelegate
  func returnDelegateScreen1() -> protocolVCMain

  // функции обновления newOperation
  func openAlertDatePicker()
  func screen2StatusIsEditingStart()

  func setVCSetting(amount: Double, category: String, date: Date, note: String, id: UUID)
}

struct Screen2MenuData {
  let name: String
  let text: String
}


class VCSetting: UIViewController {
  // MARK: - объявление аутлетов

  @IBOutlet var screen2SegmentControl: UISegmentedControl!
  @IBOutlet var tableViewScreen2: UITableView!
  @IBOutlet var screen2CurrencyStatus: UIButton!
  @IBOutlet var containerBottomScreen2: UIView!
  @IBOutlet var constraintContainerBottomPoint: NSLayoutConstraint!
  @IBOutlet var constraintContainerBottomHeight: NSLayoutConstraint!
  @IBOutlet var textFieldAmount: UITextField!
  @IBOutlet var labelScreen2Header: UILabel!

  // MARK: - делегаты, переменные
  var vcMainDelegate: protocolVCMain?
  private var delegateScreen2Container: protocolScreen2ContainerDelegate?
  var delegateScreen2TableViewCellCategory: protocolScreen2TableViewCellCategory?
  var delegateScreen2TableViewCellNote: protocolScreen2TableVCNoteDelegate?
  var delegateScreen2TableViewCellDate: protocolScreen2TableVCDateDelegate?
  var vcSettingStatusEditing = false // показывает, создаётся ли новая операция, или редактируется предыдущая

  var tapOfChangeCategoryOpenPopUp: UITapGestureRecognizer?
  var tapOutsideTextViewToGoFromTextView: UITapGestureRecognizer?
  var keyboardHeight: CGFloat = 0 // хранит высоту клавиатуры

  var screen2MenuArray: [Screen2MenuData] = []
  var newOperation: Operation?

  // MARK: - объекты
  let alertDatePicker = UIAlertController(title: "Select date", message: nil, preferredStyle: .actionSheet)
  let alertErrorAddNewOperation = UIAlertController(
    title: "Добавьте обязательные данные",
    message: nil,
    preferredStyle: .alert
  )
  let blurViewScreen2 = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
  let datePicker = UIDatePicker()

  // MARK: - переходы
  @IBAction func buttonToAddNewOperation(_ sender: Any) {
    let newOperation = SettingViewModel.shared.returnNewOperation()
    if !newOperation.category.isEmpty && textFieldAmount.text != "0" {
      // set Amount
      print("2. screen2SegmentControl.selectedSegmentIndex= \(screen2SegmentControl.selectedSegmentIndex)")
      if screen2SegmentControl.selectedSegmentIndex == 0 {
        print("textFieldAmount.text= \(textFieldAmount.text as Optional)")
        SettingViewModel.shared.setAmountInNewOperation(amount: Double(textFieldAmount.text ?? "0")!)
      } else if screen2SegmentControl.selectedSegmentIndex == 1 {
        SettingViewModel.shared.setAmountInNewOperation(amount: -Double(textFieldAmount.text ?? "0")!)
      }

      // set Date
      if delegateScreen2TableViewCellDate?.returnDateTextField().text == "Today" {
        let dateNow = Date.init()
        SettingViewModel.shared.setDateInNewOperation(date: dateNow)
      } else {
        SettingViewModel.shared.setDateInNewOperation(date: datePicker.date)
      }

      // set Note
      if delegateScreen2TableViewCellNote?.returnNoteView().text! == "Placeholder" {
        SettingViewModel.shared.setNoteInNewOperation(note: "")
      } else {
        SettingViewModel.shared.setNoteInNewOperation(note: (delegateScreen2TableViewCellNote?.returnNoteView().text!)!)
      }

      print("newOperation.amount= \(newOperation.amount), newOperation.category= \(newOperation.category), newOperation.date= \(newOperation.date), newOperation.note= \(newOperation.note),")

      if vcSettingStatusEditing == true {
        print("newOperation.amount222= \(newOperation.amount)")
        print("newOperation.date222= \(newOperation.date)")
        vmMain.shared.editOperationInRealm(
          newAmount: newOperation.amount,
          newCategory: newOperation.category,
          newNote: newOperation.note,
          newDate: newOperation.date,
          id: newOperation.id
        )
      } else {
        vmMain.shared.addOperationInRealm(
          newAmount: newOperation.amount,
          newCategory: newOperation.category,
          newNote: newOperation.note,
          newDate: newOperation.date
        )
      }

      vcMainDelegate?.updateScreen()
      dismiss(animated: true, completion: nil)
    } else {
      self.present(alertErrorAddNewOperation, animated: true, completion: nil)
    }
  }

  @IBAction func buttonCloseScreen2(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? VCScreen2Container, segue.identifier == "segueToScreen2Container" {
      delegateScreen2Container = viewController
      viewController.delegateScreen2 = self
    }
  }


  // MARK: - Alerts
  func createAlertAddNewOperations() {
    alertErrorAddNewOperation.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil ))

    let labelAlertAddNewOperations = UILabel.init(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
    labelAlertAddNewOperations.numberOfLines = 2
    labelAlertAddNewOperations.text = "Выберите категорию операции и сумму."
    alertErrorAddNewOperation.view.addSubview(labelAlertAddNewOperations)
    labelAlertAddNewOperations.translatesAutoresizingMaskIntoConstraints = false

    alertErrorAddNewOperation.view.translatesAutoresizingMaskIntoConstraints = false

    alertErrorAddNewOperation.view.addConstraint(NSLayoutConstraint(
      item: labelAlertAddNewOperations,
      attribute: .width,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: 180)
    )
    alertErrorAddNewOperation.view.addConstraint(NSLayoutConstraint(
      item: labelAlertAddNewOperations,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: 50)
    )

    alertErrorAddNewOperation.view.addConstraint(NSLayoutConstraint(
      item: labelAlertAddNewOperations,
      attribute: .centerX,
      relatedBy: .equal,
      toItem: alertErrorAddNewOperation.view,
      attribute: .centerX,
      multiplier: 1,
      constant: 0)
    )
    alertErrorAddNewOperation.view.addConstraint(NSLayoutConstraint(
      item: labelAlertAddNewOperations,
      attribute: .top,
      relatedBy: .equal,
      toItem: alertErrorAddNewOperation.view,
      attribute: .top,
      multiplier: 1,
      constant: 80)
    )
    alertErrorAddNewOperation.view.addConstraint(NSLayoutConstraint(
      item: labelAlertAddNewOperations,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: alertErrorAddNewOperation.view,
      attribute: .bottom,
      multiplier: 1,
      constant: 40
    ))

  alertErrorAddNewOperation.view.addConstraint(NSLayoutConstraint(
    item: alertErrorAddNewOperation.view!,
    attribute: .height,
    relatedBy: .equal,
    toItem: nil,
    attribute: .notAnAttribute,
    multiplier: 1.0,
    constant: labelAlertAddNewOperations.frame.height + 140
  ))

    print(alertErrorAddNewOperation.view.frame.width)
    print(labelAlertAddNewOperations.frame.width)
  }

  func createAlertDatePicker() {
    alertDatePicker.addAction(UIAlertAction(
      title: "Установить дату",
      style: .default) { _ in self.donePressed() }
    )
    alertDatePicker.addAction(UIAlertAction(title: "Cancell", style: .cancel, handler: nil ))
    alertDatePicker.view.addSubview(datePicker)

    let alertHeightConstraint = NSLayoutConstraint(
      item: alertDatePicker.view!,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1,
      constant: datePicker.frame.height + 150)
    alertDatePicker.view.addConstraint(alertHeightConstraint)
    datePicker.frame.origin.x = (alertDatePicker.view.frame.width - datePicker.frame.width) / 2
    datePicker.frame.origin.y = 25
  }


  // MARK: - DatePicker
  func createDatePicker() {
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.datePickerMode = .date
    datePicker.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
    datePicker.maximumDate = Date.init()
  }

  func donePressed() {
    SettingViewModel.shared.setDateInNewOperation(date: datePicker.date)
    tableViewScreen2Update(row: 2)
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

  @IBAction func screen2SegmentControlAction(_ sender: Any) {
    textFieldAmount.endEditing(true)
    delegateScreen2TableViewCellNote?.tapOutsideNoteTextViewEditToHide()
    switch screen2SegmentControl.selectedSegmentIndex {
    case 0:
      screen2CurrencyStatus.setTitle("+$", for: .normal)
      screen2CurrencyStatus.setTitleColor(
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
      screen2CurrencyStatus.setTitle("-$", for: .normal)
      screen2CurrencyStatus.setTitleColor(UIColor.red, for: .normal)
      textFieldAmount.textColor = UIColor.red
    default:
      break
    }
  }

  @objc func screen2TapHandler(tap: UITapGestureRecognizer) {
    if tap.state == UIGestureRecognizer.State.ended {
      print("Tap TextView ended")
      let pointOfTap = tap.location(in: self.view)

      // Tap inside noteTextView
      if delegateScreen2TableViewCellNote!.returnNoteView().frame.contains(pointOfTap) {
        textFieldAmount.endEditing(true)
        print("Tap inside noteTextView")
      }

      // Tap inside in dateTextView
      else if delegateScreen2TableViewCellDate!.returnDateTextField().frame.contains(pointOfTap) {
        textFieldAmount.endEditing(true)
        delegateScreen2TableViewCellNote?.tapOutsideNoteTextViewEditToHide()
        print("Tap inside in dateTextView")
      }

      // Tap inside in textFieldAmount
      else if textFieldAmount.frame.contains(pointOfTap) {
        print("Tap inside in textFieldAmount")
        delegateScreen2TableViewCellNote?.tapOutsideNoteTextViewEditToHide()
      } else {
        // Tap outside noteTextView and dateTextView and textFieldAmount
        textFieldAmount.endEditing(true)
        delegateScreen2TableViewCellNote?.tapOutsideNoteTextViewEditToHide()
        print("Tap outside noteTextView and dateTextView and textFieldAmount")
      }
    }
  }

  @objc func handlerToHideContainerScreen2(tap: UITapGestureRecognizer) {
    if tap.state == UIGestureRecognizer.State.ended {
      print("Tap ended")
      let pointOfTap = tap.location(in: self.view)
      if containerBottomScreen2.frame.contains(pointOfTap) {
        print("Tap inside Container")
      } else {
        print("Tap outside Container")
        changeCategoryClosePopUpScreen2()
      }
    }
  }


  // MARK: - viewWillAppear
  override func viewWillAppear(_ animated: Bool) {
    if vcSettingStatusEditing == true {
      screen2StatusIsEditingStart()
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
    SettingViewModel.shared.screen2DataReceive()
    SettingViewModel.shared.menuArrayCalculate()
    self.view.insertSubview(self.blurViewScreen2, belowSubview: self.containerBottomScreen2)
    self.blurViewScreen2.backgroundColor = .clear
    self.blurViewScreen2.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.blurViewScreen2.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.blurViewScreen2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.blurViewScreen2.heightAnchor.constraint(equalTo: self.view.heightAnchor),
      self.blurViewScreen2.widthAnchor.constraint(equalTo: self.view.widthAnchor)
    ])
    self.blurViewScreen2.isHidden = true

    self.view.layoutIfNeeded()
    // print("screen2MenuArray.count: \(screen2MenuArray.count)")

    self.tapOutsideTextViewToGoFromTextView = UITapGestureRecognizer(
      target: self,
      action: #selector(self.screen2TapHandler(tap:))
    )
    self.view.addGestureRecognizer(self.tapOutsideTextViewToGoFromTextView!)

    createDatePicker()
    createAlertDatePicker()
    createAlertAddNewOperations()
  }


  // MARK: - other functions
  @objc func keyboardWillAppear(_ notification: Notification) {
    print("keyboardWillAppear")
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      keyboardHeight = keyboardRectangle.height
    }
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        if self.constraintContainerBottomPoint.constant == 50 {
          self.constraintContainerBottomPoint.constant = self.keyboardHeight + CGFloat.init(20)
        }
        self.view.layoutIfNeeded()
      },
      completion: { _ in }
    )
  }


  @objc func keyboardWillDisappear(_ notification: Notification) {
    if keyboardHeight != 0 {
      print("keyboardWillDisappear")
      keyboardHeight = 0
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: UIView.AnimationOptions(),
        animations: {
          if self.constraintContainerBottomPoint.constant > 50 {
            self.constraintContainerBottomPoint.constant = CGFloat.init(50)
          }
          self.view.layoutIfNeeded()
        },
        completion: { _ in }
      )
    }
  }
}


// MARK: - additional protocols
extension VCSetting: protocolVCSetting {
  func returnDelegateScreen1() -> protocolVCMain {
    return vcMainDelegate!
  }

  func screen2StatusIsEditingStart() {
    print("1. screen2SegmentControl.selectedSegmentIndex= \(screen2SegmentControl.selectedSegmentIndex)")

    // set Amount
    let newOperation = SettingViewModel.shared.returnNewOperation()
    if newOperation.amount > 0 {
      screen2SegmentControl.selectedSegmentIndex = 0
    } else if newOperation.amount < 0 {
      screen2SegmentControl.selectedSegmentIndex = 1
      newOperation.amount = -newOperation.amount
    }

    if newOperation.amount.truncatingRemainder(dividingBy: 1) == 0 {
      textFieldAmount.text = "\(String(format: "%.0f", newOperation.amount))"
    } else {
      textFieldAmount.text = "\(String(format: "%.2f", newOperation.amount))"
    }

    switch screen2SegmentControl.selectedSegmentIndex {
    case 0:
      screen2CurrencyStatus.setTitle("+$", for: .normal)
      screen2CurrencyStatus.setTitleColor(
        UIColor(
          cgColor: CGColor.init(
            srgbRed: 0.165,
            green: 0.671,
            blue: 0.014,
            alpha: 1
          )
        ),
        for: .normal
      )
      textFieldAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    case 1:
      screen2CurrencyStatus.setTitle("-$", for: .normal)
      screen2CurrencyStatus.setTitleColor(UIColor.red, for: .normal)
      textFieldAmount.textColor = UIColor.red
    default:
      break
    }

    // set Date
    datePicker.date = newOperation.date

    // set Note
    delegateScreen2TableViewCellNote?.setNoteViewText(newText: newOperation.note)
    print("newOperation.note= \(newOperation.note)")

    labelScreen2Header.text = "Edit"
  }

  func openAlertDatePicker() {
    self.present(alertDatePicker, animated: true, completion: nil)
  }

  func tableViewScreen2Update(row: Int) {
    print("tableViewScreen2Update activated")
    let indexPath = IndexPath.init(row: row, section: 0)
    tableViewScreen2.reloadRows(at: [indexPath], with: .fade)
  }

  func returnDelegateScreen2TableViewCellNote() -> protocolScreen2TableVCNoteDelegate {
    return delegateScreen2TableViewCellNote!
  }


  // MARK: - окрытие PopUp-окна

  func changeCategoryOpenPopUpScreen2(_ tag: Int) {
    self.containerBottomScreen2.layer.cornerRadius = 20
    self.constraintContainerBottomHeight.constant = CGFloat(50 * 6)
    textFieldAmount.endEditing(true)
    delegateScreen2TableViewCellNote?.tapOutsideNoteTextViewEditToHide()

    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        self.constraintContainerBottomPoint.constant = 50
        self.tapOfChangeCategoryOpenPopUp = UITapGestureRecognizer(
          target: self,
          action: #selector(self.handlerToHideContainerScreen2(tap:))
        )
        self.view.addGestureRecognizer(self.tapOfChangeCategoryOpenPopUp!)
        self.blurViewScreen2.isHidden = false
        self.view.layoutIfNeeded()
      },
      completion: { _ in }
    )
  }


  // MARK: - закрытие PopUp-окна
  func changeCategoryClosePopUpScreen2() {
    tableViewScreen2Update(row: 1)
    UIView.animate(
      withDuration: 0,
      delay: 0,
      usingSpringWithDamping: 0,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        self.constraintContainerBottomPoint.constant = -515
        self.blurViewScreen2.isHidden = true
        self.view.endEditing(true)
        self.view.removeGestureRecognizer(self.tapOfChangeCategoryOpenPopUp!)
        self.view.layoutIfNeeded()
        if self.delegateScreen2Container?.returnScreen2StatusEditContainer() == true {
          self.delegateScreen2Container?
            .returnDelegateScreen2ContainerTableVCNewCategory()
            .textFieldNewCategoryClear()
        }
      },
      completion: { _ in })
  }
}
