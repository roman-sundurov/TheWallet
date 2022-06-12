//
//  TableViewCellChangeCategoryScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 23.01.2021.
//

import UIKit
import SimpleCheckbox

protocol protocolScreen2ContainerTableVCChangeCategory {
  func returnCategryIdOfCell() -> Int
  func closeEditing()
  func setPermitionToSetCategory(status: Bool)
}

class Screen2ContainerTableVCChangeCategory: UITableViewCell, UITextFieldDelegate {
  // MARK: - объявление аутлетов
  @IBOutlet var textFieldNameCategory: UITextField!
  @IBOutlet var buttonDeleteCategory: UIButton!
  @IBOutlet var buttonEditNameCategory: UIButton!
  @IBOutlet var buttonConfirmNewName: UIButton!
  @IBOutlet var checkBoxObject: Checkbox!
  @IBOutlet var constaraintCellChangeCategoryHeight: NSLayoutConstraint!


  // MARK: - делегаты и переменные

  var delegateScreen2Container: protocolScreen2ContainerDelegate?
  var specCellTag: Int = 0
  var gestureCell: UIGestureRecognizer?
  var gestureCheckBox: UIGestureRecognizer?
  var editStatus = false
  var permitionToSetCategory = true


  // MARK: - переходы

  @IBAction func buttonDeleteCategoryAction(_ sender: Any) {
    ViewModelScreen1.shared.deleteCategoryInRealm(id: specCellTag)
    delegateScreen2Container?.screen2ContainerDeleteCategory(index: specCellTag)
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
      delegateScreen2Container?.setCurrentActiveEditingCell(categoryID: ViewModelScreen2.shared
        .returnDataArrayOfCategory()[specCellTag]
        .id)
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
    ViewModelScreen2.shared.setCategoryInNewOperation(category: textFieldNameCategory.text!)
    delegateScreen2Container?.closeWindows(specCellTag) // закрытие PopUp-окна
    delegateScreen2Container?.setCurrentActiveEditingCell(categoryID: 100)
    print("ClosePopup from ContainerCell")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func startCell() {
    textFieldNameCategory.text = ViewModelScreen2.shared.returnDataArrayOfCategory()[specCellTag]
      .name
    gestureCell = UITapGestureRecognizer(target: self, action: #selector(closeWindows))
    gestureCheckBox = UITapGestureRecognizer(target: self, action: #selector(closeWindows))
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

    if ViewModelScreen2.shared.returnNewOperation().category == ViewModelScreen2.shared.returnDataArrayOfCategory()[specCellTag]
      .name {
        checkBoxObject.isChecked = true
    } else {
      checkBoxObject.isChecked = false
    }

    if delegateScreen2Container?.returnScreen2StatusEditContainer() == true {
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
    print("specCellTag ChangeCategory= \(specCellTag)")
  }
}


extension Screen2ContainerTableVCChangeCategory: protocolScreen2ContainerTableVCChangeCategory {
  func setPermitionToSetCategory(status: Bool) {
    permitionToSetCategory = status
  }

  func returnCategryIdOfCell() -> Int {
    return ViewModelScreen2.shared.returnDataArrayOfCategory()[specCellTag].id
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

    ViewModelScreen1.shared.editCategoryInRealm(newName: textFieldNameCategory.text!, newIcon: "", id: specCellTag)
    delegateScreen2Container?.setCurrentActiveEditingCell(categoryID: 0)
  }
}
