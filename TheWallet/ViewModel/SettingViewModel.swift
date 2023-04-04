//
//  ViewModelVCScreen2.swift
//  MoneyManager
//
//  Created by Roman on 28.04.2022.
//

import UIKit
import Foundation

extension VCSetting: ProtocolVCSetting {
    func showAlert(message: String) {
        let alert = UIAlertController(
          title: message,
          message: nil,
          preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil)
    }

    func setCategoryInNewOperation(categoryUUID: UUID) {
        newOperation.category = categoryUUID
    }

    func menuArrayCalculate() {
        let screen2MenuList0 = SettingMenuData(name: "Header", text: "")
        let screen2MenuList1 = SettingMenuData(name: "Category", text: "Select category")
        let screen2MenuList2 = SettingMenuData(name: "Date", text: "Today")
        let screen2MenuList3 = SettingMenuData(name: "Notes", text: "")
        settingMenuArray = [screen2MenuList0, screen2MenuList1, screen2MenuList2, screen2MenuList3]
    }

    func getSettingMenuArray() -> [SettingMenuData] {
        return settingMenuArray
    }

    func returnNewOperation() -> Operation {
        return newOperation
    }

    func startEditing() {
        print("1. screen2SegmentControl.selectedSegmentIndex= \(screen2SegmentControl.selectedSegmentIndex)")
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

            // display Date
        datePicker.date = Date.init(timeIntervalSince1970: newOperation.date)

            // display Note
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
        settingTableView.reloadRows(at: [indexPath], with: .fade)
    }

    // MARK: - open a PopUp window
    func showChangeCategoryPopUp(_ tag: Int) throws {
        if let tabBarController = tabBarController {
            tabBarController.tabBar.isUserInteractionEnabled = false
        } else {
            print("Error: UITabBarController 1")
        }
        print("changeCategoryOpenPopUpScreen2")
        self.categoryChangeView.layer.cornerRadius = 20
        textFieldAmount.endEditing(true)
        tableViewCellNoteDelegate?.tapOutsideNoteTextViewEditToHide()
        self.tapOfChangeCategoryOpenPopUp = UITapGestureRecognizer(
            target: self,
            action: #selector(self.handlerToHideContainerScreen2(tap:))
        )
        if let tapOfChangeCategoryOpenPopUp = self.tapOfChangeCategoryOpenPopUp {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: UIView.AnimationOptions(),
                animations: {
                    self.categoryChangeViewBottomConstraint.constant = 30
                    self.view.addGestureRecognizer(tapOfChangeCategoryOpenPopUp)
                    self.blurView.isHidden = false
                    self.view.layoutIfNeeded()
                },
                completion: { _ in }
            )
        } else {
            throw ThrowError.showChangeCategoryPopUpError
        }
    }

    // MARK: - close a PopUp window
    func hideChangeCategoryPopUp() throws {
        if let tabBarController = tabBarController {
            tabBarController.tabBar.isUserInteractionEnabled = true
        } else {
            print("Error: UITabBarController 1")
        }
        tableViewScreen2Update(row: 1)
        if let tapOfChangeCategoryOpenPopUp = self.tapOfChangeCategoryOpenPopUp {
            UIView.animate(
                withDuration: 0,
                delay: 0,
                usingSpringWithDamping: 0,
                initialSpringVelocity: 0,
                options: UIView.AnimationOptions(),
                animations: {
                    self.vcCategoryDelegate?.screen2ContainerNewCategorySwicher()
                    self.categoryChangeViewBottomConstraint.constant = -411
                    self.blurView.isHidden = true
                    self.view.endEditing(true)
                    self.view.removeGestureRecognizer(tapOfChangeCategoryOpenPopUp)
                    self.view.layoutIfNeeded()
                    if let vcCategoryDelegate = self.vcCategoryDelegate,
                       vcCategoryDelegate.returnScreen2StatusEditContainer() == true {
                        do {
                            try vcCategoryDelegate
                                .returnDelegateScreen2ContainerTableVCNewCategory()
                                .textFieldNewCategoryClear()
                        } catch {
                            self.showAlert(message: "Error changeCategoryClosePopUpScreen2")
                        }
                    }
                },
                completion: { _ in }
            )
        } else {
            throw ThrowError.hideChangeCategoryPopUpError
        }
    }

    // MARK: - alerts
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

    // MARK: - DatePickers
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
        datePicker.maximumDate = Date.init()
    }

    func donePressed() {
        newOperation.date = datePicker.date.timeIntervalSince1970
        tableViewScreen2Update(row: 2)
    }

    // MARK: - @objc functions
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
                if self.categoryChangeViewBottomConstraint.constant == 30 {
                    self.categoryChangeViewBottomConstraint.constant = self.keyboardHeight + CGFloat.init(30)
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
                    if self.categoryChangeViewBottomConstraint.constant > 30 {
                        self.categoryChangeViewBottomConstraint.constant = CGFloat.init(30)
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
            if let tableViewCellNoteDelegate = tableViewCellNoteDelegate,
               tableViewCellNoteDelegate.returnNoteView().frame.contains(pointOfTap) {
                textFieldAmount.endEditing(true)
                print("Tap inside noteTextView")

            // Tap inside in dateTextView
            } else if let tableViewCellDateDelegate = tableViewCellDateDelegate,
                    tableViewCellDateDelegate.returnDateTextField().frame.contains(pointOfTap) {
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
            print("Tap ended2")
            let pointOfTap = tap.location(in: self.view)
            if categoryChangeView.frame.contains(pointOfTap) {
                print("Tap inside Container2")
            } else {
                print("Tap outside Container2")
                do {
                    try hideChangeCategoryPopUp()
                } catch {
                    showAlert(message: "Error handlerToHideContainerScreen2")
                }
            }
        }
    }
}

extension VCSetting: UITextFieldDelegate {
    func createDoneButton() -> UIView {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(self.doneButtonAction)
        )

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        return doneToolbar
    }

    @objc func doneButtonAction() {
        textFieldAmount.resignFirstResponder()
    }
}
