//
//  TableViewCellChangeCategoryScreen2Container.swift
//  MoneyManager
//
//  Created by Roman on 23.01.2021.
//

import UIKit
import SimpleCheckbox

protocol ProtocolCategoryTableVCCategory {
    func returnCategryIdOfCell() throws -> Int
    func closeEditing() throws
    func setPermitionToSetCategory(status: Bool)
}

final class CategoryTableVCCategory: UITableViewCell, UITextFieldDelegate {
        // MARK: - outlets
    @IBOutlet var textFieldNameCategory: UITextField!
    @IBOutlet var buttonDeleteCategory: UIButton!
    @IBOutlet var buttonEditNameCategory: UIButton!
    @IBOutlet var buttonConfirmNewName: UIButton!
    @IBOutlet var checkBoxObject: Checkbox!
    @IBOutlet var constaraintCellChangeCategoryHeight: NSLayoutConstraint!

        // MARK: - delegates and variables
    var vcMainDelegate: ProtocolVCMain?
    var vcSettingDelegate: ProtocolVCSetting?
    var vcCategoryDelegate: ProtocolVCCategory?
    var gestureCell: UIGestureRecognizer?
    var gestureCheckBox: UIGestureRecognizer?
    var editStatus = false
    var permitionToSetCategory = true
    var category: Category?
    var cellID: Int?

        // MARK: - transitions
    @IBAction func buttonDeleteCategoryAction(_ sender: Any) {
        if let vcMainDelegate = vcMainDelegate,
           let vcCategoryDelegate = vcCategoryDelegate,
           let category = category {
            vcMainDelegate.deleteCategory(idOfObject: category.id)
            vcCategoryDelegate.screen2ContainerDeleteCategory(idOfObject: category.id)
        } else {
            vcSettingDelegate?.showAlert(message: "Error: CategoryTableVCCategory buttonDeleteCategoryAction")
            print("Error: CategoryTableVCCategory buttonDeleteCategoryAction")
        }
    }

    @IBAction func buttonsEditNameCategoryAction(_ sender: Any) {
        if let vcCategoryDelegate = vcCategoryDelegate,
           let cellID = cellID {
            if editStatus == false {
                editStatus = true
                textFieldNameCategory.backgroundColor = UIColor.white
                textFieldNameCategory.textColor = UIColor.systemGray
                textFieldNameCategory.isEnabled = true
                textFieldNameCategory.becomeFirstResponder()
                checkBoxObject.isUserInteractionEnabled = false
                print("buttonEditNameCategoryAction1")
                buttonEditNameCategory.tintColor = UIColor.red
                buttonEditNameCategory.isHidden = true
                buttonConfirmNewName.isHidden = false
                vcCategoryDelegate.setCurrentActiveEditingCell(cellID: cellID)
            } else {
                try? closeEditing()
            }
        } else {
            vcSettingDelegate?.showAlert(message: "Error: CategoryTableVCCategory buttonDeleteCategoryAction")
            print("Error: CategoryTableVCCategory buttonDeleteCategoryAction")
        }
    }

    // func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //     if let buttonConfirmNewName = buttonConfirmNewName {
    //         buttonsEditNameCategoryAction(buttonConfirmNewName!)
    //         return true
    //     }
    // }

    @objc func closeWindows(tap: UITapGestureRecognizer) {
        if permitionToSetCategory == false { return }
            // запись выбранной категории во временную переменную
        if let vcSettingDelegate = vcSettingDelegate,
           let vcCategoryDelegate = vcCategoryDelegate,
           let category = category {
                vcSettingDelegate.setCategoryInNewOperation(categoryUUID: category.id)
                vcCategoryDelegate.closeWindow() // закрытие PopUp-окна
                vcCategoryDelegate.setCurrentActiveEditingCell(cellID: 100)
                print("ClosePopup from ContainerCell")
        } else {
            vcSettingDelegate?.showAlert(message: "Error: CategoryTableVCCategory closeWindows")
            print("Error: CategoryTableVCCategory closeWindows")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func startCell(category: Category, cellID: Int) {
        self.cellID = cellID
        self.category = category
        print("cellID ChangeCategory= \(cellID)")
        textFieldNameCategory.text = category.name
        gestureCell = UITapGestureRecognizer(target: self, action: #selector(self.closeWindows(tap:)))
        gestureCheckBox = UITapGestureRecognizer(target: self, action: #selector(self.closeWindows(tap:)))
        isUserInteractionEnabled = true
        if let gestureCell = gestureCell,
           let gestureCheckBox = gestureCheckBox,
           let vcSettingDelegate = vcSettingDelegate,
           let vcCategoryDelegate = vcCategoryDelegate,
           let category = self.category {
            addGestureRecognizer(gestureCell)
            checkBoxObject.addGestureRecognizer(gestureCheckBox)

            if vcSettingDelegate.returnNewOperation().category == category.id {
                checkBoxObject.isChecked = true
            } else {
                checkBoxObject.isChecked = false
            }
            if vcCategoryDelegate.returnScreen2StatusEditContainer() == true {
                buttonDeleteCategory.isHidden = false
                buttonEditNameCategory.isHidden = false
            } else {
                buttonDeleteCategory.isHidden = true
                buttonEditNameCategory.isHidden = true
            }

        } else {
            vcSettingDelegate?.showAlert(message: "Error: CategoryTableVCCategory startCell")
            print("Error: CategoryTableVCCategory startCell")
        }
        checkBoxObject.tag = cellID
        checkBoxObject.checkmarkStyle = .tick
        checkBoxObject.borderLineWidth = 0
        checkBoxObject.borderStyle = .circle
        checkBoxObject.checkmarkSize = 1
        checkBoxObject.checkmarkColor = .white
        textFieldNameCategory.layer.cornerRadius = 10
        textFieldNameCategory.returnKeyType = .done
        textFieldNameCategory.delegate = self
    }
}

extension CategoryTableVCCategory: ProtocolCategoryTableVCCategory {
    func setPermitionToSetCategory(status: Bool) {
        permitionToSetCategory = status
    }

    func returnCategryIdOfCell() throws -> Int {
        if let cellID = cellID {
            return cellID
        } else {
            throw ThrowError.categoryTableVCCategoryReturnCategryIdOfCell
        }
    }

    func closeEditing() throws {
        editStatus = false
        textFieldNameCategory.backgroundColor = UIColor.clear
        textFieldNameCategory.textColor = UIColor.white
        textFieldNameCategory.isEnabled = false
        textFieldNameCategory.resignFirstResponder()
        checkBoxObject.isUserInteractionEnabled = true
        print("buttonEditNameCategoryAction2")
        buttonEditNameCategory.tintColor = UIColor.systemBlue
        buttonEditNameCategory.isHidden = false
        buttonConfirmNewName.isHidden = true
        if let textFieldNameCategoryText = textFieldNameCategory.text,
           let category = self.category {
            vcMainDelegate?.updateCategory(name: textFieldNameCategoryText, icon: "", idOfObject: category.id)
            vcCategoryDelegate?.setCurrentActiveEditingCell(cellID: 0)
        } else {
            print("Error: CategoryTableVCCategory closeEditing")
            throw ThrowError.categoryTableVCCategoryCloseEditing
        }
    }
}
