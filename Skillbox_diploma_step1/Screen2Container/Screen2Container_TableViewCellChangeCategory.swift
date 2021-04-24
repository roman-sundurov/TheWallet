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
    @IBOutlet var labelChangeCategory: UILabel!
    @IBOutlet var buttonDeleteCategory: UIButton!
    @IBOutlet var buttonChangeNameCategory: UIButton!
    @IBOutlet var checkBoxObject: Checkbox!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen2Container: protocolScreen2ContainerDelegate?
    var specCellTag: Int = 0
    
    
    //MARK: - переходы
    
    @IBAction func buttonDeleteCategoryAction(_ sender: Any) {
        delegateScreen2Container?.buttonDeleteCategoryHandler(checkBoxObject.tag)
    }
    
    
    @IBAction func buttonChangeNameCategoryAction(_ sender: Any) {
    }
    
    
    @objc func closeWindows() {
        delegateScreen2Container?.returnDelegateScreen2().setCategoryInNewOperation(category: labelChangeCategory.text!) //запись выбранной категории во временную переменную
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
    
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        switch checkBoxObject.isChecked {
        case true:
            delegateScreen2Container?.checkBoxStatus(checkBoxObject.tag, true)
        case false:
            delegateScreen2Container?.checkBoxStatus(checkBoxObject.tag, false)
        }
    }
    
    func startCell() {
        checkBoxObject.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        labelChangeCategory.text = delegateScreen2Container?.returnDelegateScreen2().returnDataArrayOfCategory()[specCellTag].name
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeWindows))
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        checkBoxObject.tag = specCellTag
        checkBoxObject.checkmarkStyle = .tick
        checkBoxObject.borderLineWidth = 0
        checkBoxObject.borderStyle = .circle
        checkBoxObject.checkmarkSize = 1
        checkBoxObject.checkmarkColor = .white
        
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
    }

}
