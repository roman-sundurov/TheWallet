//
//  VCSetting.swift
//  MoneyManager
//
//  Created by Roman on 16.01.2021.
//

import UIKit
import Foundation

protocol ProtocolVCSetting {
    func hideChangeCategoryPopUp() throws
    func showChangeCategoryPopUp(_ tag: Int) throws
    func tableViewScreen2Update(row: Int)
    func setCategoryInNewOperation(categoryUUID: UUID)
    func openAlertDatePicker()
    func startEditing()
    func returnNewOperation() -> Operation
    func getSettingMenuArray() -> [SettingMenuData]
    func showAlert(message: String)
}

struct SettingMenuData {
    let name: String
    let text: String
}

class VCSetting: UIViewController {
    // MARK: - outlets
    @IBOutlet var screen2SegmentControl: UISegmentedControl!
    @IBOutlet var settingTableView: UITableView!
    @IBOutlet var screen2CurrencyDirection: UIButton!
    @IBOutlet var categoryChangeView: UIView!
    @IBOutlet var categoryChangeViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var textFieldAmount: UITextField!
    @IBOutlet var labelScreen2Header: UILabel!
    @IBOutlet var closeButton: UIButton!

    // MARK: - delegates and variables
    var vcMainDelegate: ProtocolVCMain?
    var vcCategoryDelegate: VCCategory?
    var tableViewCellNoteDelegate: ProtocolSettingTableVCNote?
    var tableViewCellDateDelegate: ProtocolSettingTableVCDate?
    var tapOfChangeCategoryOpenPopUp: UITapGestureRecognizer?
    var tapOutsideTextViewToGoFromTextView: UITapGestureRecognizer?
    var keyboardHeight: CGFloat = 0 // хранит высоту клавиатуры
    var settingMenuArray: [SettingMenuData] = []
    var newOperation = Operation(amount: 0, category: nil, note: "", date: Date().timeIntervalSince1970, id: UUID())

    // MARK: - objects
    let alertDatePicker = UIAlertController(title: "Select date", message: nil, preferredStyle: .actionSheet)
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let datePicker = UIDatePicker()

    // MARK: - transitions
    @IBAction func buttonToAddNewOperation(_ sender: Any) {
        var newOperation = returnNewOperation()
        if let newOperationCategory = newOperation.category,
           let returnNoteViewText = tableViewCellNoteDelegate?.returnNoteView().text,
           let textFieldAmountText = textFieldAmount.text,
           let textFieldAmountDouble = Double(textFieldAmountText),
           textFieldAmount.text != "0" {
            // set Amount
            print("2. screen2SegmentControl.selectedSegmentIndex= \(screen2SegmentControl.selectedSegmentIndex)")
            if screen2SegmentControl.selectedSegmentIndex == 0 {
                print("textFieldAmount.text= \(textFieldAmount.text as Optional)")
                newOperation.amount = textFieldAmountDouble
            } else if screen2SegmentControl.selectedSegmentIndex == 1 {
                newOperation.amount = -textFieldAmountDouble
            }
                // set Date
            if tableViewCellDateDelegate?.returnDateTextField().text == "Today" {
                newOperation.date = Date().timeIntervalSince1970
            } else {
                newOperation.date = datePicker.date.timeIntervalSince1970
            }
                // set Note
            if returnNoteViewText == "Placeholder" {
                newOperation.note = ""
            } else {
                newOperation.note = returnNoteViewText
            }
            if dataManager.operationForEditing != nil {
                do {
                    try dataManager.updateOperations(
                        amount: newOperation.amount,
                        categoryUUID: newOperationCategory,
                        note: newOperation.note,
                        date: Date.init(timeIntervalSince1970: newOperation.date),
                        idOfObject: newOperation.id
                    )
                } catch {
                    showAlert(message: "Error updateOperations")
                }
            } else {
                do {
                    try dataManager.addOperations(
                        amount: newOperation.amount,
                        categoryUUID: newOperationCategory,
                        note: newOperation.note,
                        date: Date.init(timeIntervalSince1970: newOperation.date)
                    )
                } catch {
                    showAlert(message: "Error addOperations")
                }
            }
            newOperation = Operation(amount: 0, category: nil, note: "", date: Date().timeIntervalSince1970, id: UUID())

            if dataManager.operationForEditing != nil {
                vcMainDelegate?.updateScreen()
                dataManager.operationForEditing = nil
                dismiss(animated: true, completion: nil)
            } else {

                if let tabBarController = self.tabBarController,
                   let childViewControllers = tabBarController.viewControllers,
                   let vcMain = childViewControllers.first(where: { $0 is ProtocolVCMain }) as? ProtocolVCMain {
                    tabBarController.selectedIndex = 2
                    vcMain.updateScreen()
                } else {
                    showAlert(message: "Error vcSettingVcMainUpdateScreen")
                    print("Error vcSettingVcMainUpdateScreen")
                }

            }
        } else {
            showAlert(message: "Add required data: select transaction category and amount.")
            dataManager.operationForEditing = nil
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

    // MARK: - clicks
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

    // MARK: - lifecycle
    override func viewWillAppear(_ animated: Bool) {
        if dataManager.operationForEditing != nil {
            startEditing()
            labelScreen2Header.text = "Edit operation"
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let operationForEditing = dataManager.operationForEditing {
            newOperation.amount = operationForEditing.amount
            newOperation.category = operationForEditing.category
            newOperation.date = operationForEditing.date
            newOperation.note = operationForEditing.note
            newOperation.id = operationForEditing.id
            closeButton.isHidden = false
        }

        menuArrayCalculate()
        self.view.insertSubview(self.blurView, belowSubview: self.categoryChangeView)
        self.blurView.backgroundColor = .clear
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.blurView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.blurView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.blurView.isHidden = true
        self.view.layoutIfNeeded()

        self.tapOutsideTextViewToGoFromTextView = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapHandler(tap:))
        )
        if let tapOutsideTextViewToGoFromTextView = tapOutsideTextViewToGoFromTextView {
            self.view.addGestureRecognizer(tapOutsideTextViewToGoFromTextView)
        } else {
            showAlert(message: "Error addGestureRecognizer")
        }
        createDatePicker()
        createAlertDatePicker()

        textFieldAmount.layer.borderColor = UIColor.gray.cgColor
        textFieldAmount.layer.borderWidth = 2
        textFieldAmount.layer.cornerRadius = 10
        textFieldAmount.clipsToBounds = true

        textFieldAmount.delegate = self
        textFieldAmount.inputAccessoryView = createDoneButton()
    }
}
