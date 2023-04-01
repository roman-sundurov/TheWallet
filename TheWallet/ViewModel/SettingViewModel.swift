//
//  ViewModelVCScreen2.swift
//  MoneyManager
//
//  Created by Roman on 28.04.2022.
//

import UIKit
import Foundation

extension VCSetting: ProtocolVCSetting {

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

    func setVCSetting(amount: Double, categoryUUID: UUID, date: Double, note: String, id: UUID) {
        newOperation.amount = amount
        newOperation.category = categoryUUID
        newOperation.date = date
        newOperation.note = note
        newOperation.id = id
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

    func returnDelegateScreen2TableViewCellNote() throws -> ProtocolSettingTableVCNote {
        if let tableViewCellNoteDelegate = tableViewCellNoteDelegate {
            return tableViewCellNoteDelegate
        } else {
            throw ThrowError.returnDelegateScreen2TableViewCellNote
        }
    }

    // MARK: - open a PopUp window
    func changeCategoryOpenPopUpScreen2(_ tag: Int) throws {
        print("changeCategoryOpenPopUpScreen2")
        self.categoryChangeView.layer.cornerRadius = 20
        self.constraintCategoryChangeViewHeight.constant = CGFloat(50 * 6)
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
                    self.constraintCategoryChangeViewPoint.constant = 50
                    self.view.addGestureRecognizer(tapOfChangeCategoryOpenPopUp)
                    self.blurView.isHidden = false
                    self.view.layoutIfNeeded()
                },
                completion: { _ in }
            )
        } else {
            throw ThrowError.changeCategoryOpenPopUpScreen2
        }
    }

    // MARK: - close a PopUp window
    func changeCategoryClosePopUpScreen2() throws {
        tableViewScreen2Update(row: 1)
        if let tapOfChangeCategoryOpenPopUp = self.tapOfChangeCategoryOpenPopUp {
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
            throw ThrowError.changeCategoryClosePopUpScreen2
        }
    }

    // MARK: - alerts
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
            print("Tap ended")
            let pointOfTap = tap.location(in: self.view)
            if categoryChangeView.frame.contains(pointOfTap) {
                print("Tap inside Container")
            } else {
                print("Tap outside Container")
                do {
                    try changeCategoryClosePopUpScreen2()
                } catch {
                    showAlert(message: "Error handlerToHideContainerScreen2")
                }
            }
        }
    }
}
