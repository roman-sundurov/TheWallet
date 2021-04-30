//
//  TableViewCellChangeCategoryScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 23.01.2021.
//

import UIKit
import SimpleCheckbox

class Screen2Container_TableViewCellChangeCategory: UITableViewCell {
    
    //MARK: - объявление аутлетов
    @IBOutlet var textFieldNameCategory: UITextField!
    @IBOutlet var buttonDeleteCategory: UIButton!
    @IBOutlet var buttonChangeNameCategory: UIButton!
    @IBOutlet var checkBoxObject: Checkbox!
    @IBOutlet var constaraintCellChangeCategoryHeight: NSLayoutConstraint!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen2Container: protocolScreen2ContainerDelegate?
    var specCellTag: Int = 0
    var gestureCell: UIGestureRecognizer?
    var gestureCheckBox: UIGestureRecognizer?
    var editStatus: Bool = false
    
    
    //MARK: - переходы
    
    @IBAction func buttonDeleteCategoryAction(_ sender: Any) {
        delegateScreen2Container?.returnDelegateScreen2().returnDelegateScreen1().deleteCategoryInRealm(id: specCellTag)
        delegateScreen2Container?.screen2ContainerDeleteCategory(index: specCellTag)
    }
    
    
    @IBAction func buttonEditNameCategoryAction(_ sender: Any) {
        if editStatus == false{
            editStatus = true
            textFieldNameCategory.backgroundColor = UIColor.white
            textFieldNameCategory.textColor = UIColor.systemGray
            textFieldNameCategory.isEnabled = true
            textFieldNameCategory.becomeFirstResponder()
            removeGestureRecognizer(gestureCell!)
            removeGestureRecognizer(gestureCheckBox!)
            checkBoxObject.isUserInteractionEnabled = false
            print("buttonEditNameCategoryAction1")
        }
        else{
            editStatus = false
            textFieldNameCategory.backgroundColor = UIColor.clear
            textFieldNameCategory.textColor = UIColor.white
            textFieldNameCategory.isEnabled = false
            textFieldNameCategory.resignFirstResponder()
            addGestureRecognizer(gestureCell!)
            addGestureRecognizer(gestureCheckBox!)
            checkBoxObject.isUserInteractionEnabled = true
            print("buttonEditNameCategoryAction2")
        }
    }
    
    
    @objc func closeWindows() {
        delegateScreen2Container?.returnDelegateScreen2().setCategoryInNewOperation(category: textFieldNameCategory.text!) //запись выбранной категории во временную переменную
        delegateScreen2Container?.closeWindows(specCellTag) //закрытие PopUp-окна
        print("ClosePopup from ContainerCell")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

        // Configure the view for the selected state
    }
    
    
    func startCell() {
//        checkBoxObject.addTarget(self, action: #selector(closeWindows), for: .valueChanged)
        textFieldNameCategory.text = delegateScreen2Container?.returnDelegateScreen2().returnDataArrayOfCategory()[specCellTag].name
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
        
        if delegateScreen2Container?.returnDelegateScreen2().returnNewOperation().category ==  delegateScreen2Container?.returnDelegateScreen2().returnDataArrayOfCategory()[specCellTag].name {
            checkBoxObject.isChecked = true
        }
        else{
            checkBoxObject.isChecked = false
        }
        
        if delegateScreen2Container?.returnScreen2StatusEditContainer() == true {
            buttonDeleteCategory.isHidden = false
            buttonChangeNameCategory.isHidden = false
        }
        else{
            buttonDeleteCategory.isHidden = true
            buttonChangeNameCategory.isHidden = true
        }
        
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
        print("specCellTag ChangeCategory= \(specCellTag)")
    }

}
