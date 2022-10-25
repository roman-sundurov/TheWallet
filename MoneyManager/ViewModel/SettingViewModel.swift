//
//  ViewModelVCScreen2.swift
//  MoneyManager
//
//  Created by Roman on 28.04.2022.
//

import UIKit
import Foundation

extension VCSetting: protocolVCSetting {
  func getUserData() -> User {
    return vcMainDelegate!.getUserData()
  }

  func setCategoryInNewOperation(categoryUUID: UUID) {
    newOperation?.category = categoryUUID
    }

  // MARK: - data
  func menuArrayCalculate() {
    let screen2MenuList0 = Screen2MenuData(name: "Header", text: "")
    let screen2MenuList1 = Screen2MenuData(name: "Category", text: "Select category")
    let screen2MenuList2 = Screen2MenuData(name: "Date", text: "Today")
    let screen2MenuList3 = Screen2MenuData(name: "Notes", text: "")
    screen2MenuArray = [screen2MenuList0, screen2MenuList1, screen2MenuList2, screen2MenuList3]
  }

  func returnScreen2MenuArray() -> [Screen2MenuData] {
    return screen2MenuArray
  }

  func setVCSetting(amount: Double, categoryUUID: UUID, date: Date, note: String, id: UUID) {
    newOperation?.amount = amount
    newOperation?.category = categoryUUID
    newOperation?.date = date.timeIntervalSince1970
    newOperation?.note = note
    newOperation?.id = id
  }

  func returnNewOperation() -> Operation {
    return newOperation!
  }

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
        if self.constraintCategoryChangeViewPoint.constant == 50 {
          self.constraintCategoryChangeViewPoint.constant = self.keyboardHeight + CGFloat.init(20)
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
          if self.constraintCategoryChangeViewPoint.constant > 50 {
            self.constraintCategoryChangeViewPoint.constant = CGFloat.init(50)
          }
          self.view.layoutIfNeeded()
        },
        completion: { _ in }
      )
    }
  }

  @objc func tapHandler(tap: UITapGestureRecognizer) {
    if tap.state == UIGestureRecognizer.State.ended {
      print("Tap TextView ended")
      let pointOfTap = tap.location(in: self.view)

      // Tap inside noteTextView
      if tableViewCellNoteDelegate!.returnNoteView().frame.contains(pointOfTap) {
        textFieldAmount.endEditing(true)
        print("Tap inside noteTextView")
      }

      // Tap inside in dateTextView
      else if tableViewCellDateDelegate!.returnDateTextField().frame.contains(pointOfTap) {
        textFieldAmount.endEditing(true)
        tableViewCellNoteDelegate?.tapOutsideNoteTextViewEditToHide()
        print("Tap inside in dateTextView")
      }

      // Tap inside in textFieldAmount
      else if textFieldAmount.frame.contains(pointOfTap) {
        print("Tap inside in textFieldAmount")
        tableViewCellNoteDelegate?.tapOutsideNoteTextViewEditToHide()
      } else {
        // Tap outside noteTextView and dateTextView and textFieldAmount
        textFieldAmount.endEditing(true)
        tableViewCellNoteDelegate?.tapOutsideNoteTextViewEditToHide()
        print("Tap outside noteTextView and dateTextView and textFieldAmount")
      }
    }
  }

  @objc func handlerToHideContainerScreen2(tap: UITapGestureRecognizer) {
    if tap.state == UIGestureRecognizer.State.ended {
      print("Tap ended")
      let pointOfTap = tap.location(in: self.view)
      if categoryChangeView.frame.contains(pointOfTap) {
        print("Tap inside Container")
      } else {
        print("Tap outside Container")
        changeCategoryClosePopUpScreen2()
      }
    }
  }

  func startEditing() {
    print("1. screen2SegmentControl.selectedSegmentIndex= \(screen2SegmentControl.selectedSegmentIndex)")

    // set Amount
    var newOperation = returnNewOperation()
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
      screen2CurrencyDirection.setTitle("+$", for: .normal)
      screen2CurrencyDirection.setTitleColor(
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
      screen2CurrencyDirection.setTitle("-$", for: .normal)
      screen2CurrencyDirection.setTitleColor(UIColor.red, for: .normal)
      textFieldAmount.textColor = UIColor.red
    default:
      break
    }

    // set Date
    datePicker.date = Date.init(timeIntervalSince1970: newOperation.date)

    // set Note
    tableViewCellNoteDelegate?.setNoteViewText(newText: newOperation.note)
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

  func returnDelegateScreen2TableViewCellNote() -> protocolSettingTableVCNote {
    return tableViewCellNoteDelegate!
  }

  // MARK: - окрытие PopUp-окна
  func changeCategoryOpenPopUpScreen2(_ tag: Int) {
    self.categoryChangeView.layer.cornerRadius = 20
    self.constraintCategoryChangeViewHeight.constant = CGFloat(50 * 6)
    textFieldAmount.endEditing(true)
    tableViewCellNoteDelegate?.tapOutsideNoteTextViewEditToHide()

    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        self.constraintCategoryChangeViewPoint.constant = 50
        self.tapOfChangeCategoryOpenPopUp = UITapGestureRecognizer(
          target: self,
          action: #selector(self.handlerToHideContainerScreen2(tap:))
        )
        self.view.addGestureRecognizer(self.tapOfChangeCategoryOpenPopUp!)
        self.blurView.isHidden = false
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
        self.constraintCategoryChangeViewPoint.constant = -515
        self.blurView.isHidden = true
        self.view.endEditing(true)
        self.view.removeGestureRecognizer(self.tapOfChangeCategoryOpenPopUp!)
        self.view.layoutIfNeeded()
        if self.vcCategoryDelegate?.returnScreen2StatusEditContainer() == true {
          self.vcCategoryDelegate?
            .returnDelegateScreen2ContainerTableVCNewCategory()
            .textFieldNewCategoryClear()
        }
      },
      completion: { _ in })
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
    newOperation?.date = datePicker.date.timeIntervalSince1970
    tableViewScreen2Update(row: 2)
  }

}
