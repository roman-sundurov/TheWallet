//
//  TableViewCellChangeCategoryScreen2Container.swift
//  MoneyManager
//
//  Created by Roman on 23.01.2021.
//

import UIKit
import SimpleCheckbox

protocol protocolCategoryTableVCCategory {
  func returnCategryIdOfCell() -> Int
  func closeEditing()
  func setPermitionToSetCategory(status: Bool)
}

class CategoryTableVCCategory: UITableViewCell, UITextFieldDelegate {
  // MARK: - объявление аутлетов
  @IBOutlet var textFieldNameCategory: UITextField!
  @IBOutlet var buttonDeleteCategory: UIButton!
  @IBOutlet var buttonEditNameCategory: UIButton!
  @IBOutlet var buttonConfirmNewName: UIButton!
  @IBOutlet var checkBoxObject: Checkbox!
  @IBOutlet var constaraintCellChangeCategoryHeight: NSLayoutConstraint!


  // MARK: - делегаты и переменные

  var vcMainDelegate: protocolVCMain?
  var vcSettingDelegate: protocolVCSetting
  var vcCategoryDelegate: protocolVCCategory?
  var cellID: Int?
  var categoryID: UUID?
  var gestureCell: UIGestureRecognizer?
  var gestureCheckBox: UIGestureRecognizer?
  var editStatus = false
  var permitionToSetCategory = true


  // MARK: - переходы

  @IBAction func buttonDeleteCategoryAction(_ sender: Any) {
    vcMainDelegate!.deleteCategory(idOfObject: categoryID!)

    vcCategoryDelegate?.screen2ContainerDeleteCategory(idOfObject: categoryID!)
  }

  @IBAction func buttonsEditNameCategoryAction(_ sender: Any) {
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
      vcCategoryDelegate?.setCurrentActiveEditingCell(categoryID: categoryID!)
    } else {
      closeEditing()
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    buttonsEditNameCategoryAction(buttonConfirmNewName!)
    return true
  }

  @objc func closeWindows() {
    if permitionToSetCategory == false { return }
    // запись выбранной категории во временную переменную
    vcSettingDelegate.setCategoryInNewOperation(category: textFieldNameCategory.text!)
    vcCategoryDelegate?.closeWindow() // закрытие PopUp-окна
    vcCategoryDelegate?.setCurrentActiveEditingCell(categoryID: nil)
    print("ClosePopup from ContainerCell")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func startCell(category: Category) {
    textFieldNameCategory.text = SettingViewModel.shared.returnDataArrayOfCategory()[specCellTag]
      .name
    gestureCell = UITapGestureRecognizer(target: self, action: #selector(closeWindow))
    gestureCheckBox = UITapGestureRecognizer(target: self, action: #selector(closeWindow))
    isUserInteractionEnabled = true
    addGestureRecognizer(gestureCell!)
    checkBoxObject.addGestureRecognizer(gestureCheckBox!)
    checkBoxObject.tag = specCellTag
    checkBoxObject.checkmarkStyle = .tick
    checkBoxObject.borderLineWidth = 0
    checkBoxObject.borderStyle = .circle
    checkBoxObject.checkmarkSize = 1
    checkBoxObject.checkmarkColor = .white

    textFieldNameCategory.layer.cornerRadius = 10

    if vcSettingDelegate.returnNewOperation().category == vcSettingDelegate.returnDataArrayOfCategory()[specCellTag]
      .name {
        checkBoxObject.isChecked = true
    } else {
      checkBoxObject.isChecked = false
    }

    if vcCategoryDelegate?.returnScreen2StatusEditContainer() == true {
    buttonDeleteCategory.isHidden = false
    buttonEditNameCategory.isHidden = false
    } else {
      buttonDeleteCategory.isHidden = true
      buttonEditNameCategory.isHidden = true
    }

    textFieldNameCategory.returnKeyType = .done
    textFieldNameCategory.delegate = self
  }

  func setTag(tag: Int) {
    specCellTag = tag
    print("cellID ChangeCategory= \(cellID)")
  }
}


extension CategoryTableVCCategory: protocolCategoryTableVCCategory {
  func setPermitionToSetCategory(status: Bool) {
    permitionToSetCategory = status
  }

  func returnCategryIdOfCell() -> Int {
    return vcSettingDelegate.returnDataArrayOfCategory()[specCellTag].id
  }

  func closeEditing() {
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

    vcMainDelegate?.updateCategory(name: textFieldNameCategory.text!, icon: "", idOfObject: specCellTag)
    vcCategoryDelegate?.setCurrentActiveEditingCell(categoryID: 0)
  }
}
