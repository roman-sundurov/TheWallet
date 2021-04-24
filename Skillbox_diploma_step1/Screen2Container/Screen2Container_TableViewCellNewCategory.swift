//
//  Screen2Container_TableViewCellNewCategory.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 21.04.2021.
//

import UIKit

protocol protocolScreen2Container_TableViewCellNewCategory{
    func textFieldNewCategoryClear()
}

class Screen2Container_TableViewCellNewCategory: UITableViewCell {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var textFieldNewCategory: UITextField!
    @IBOutlet var buttonAddNewCategory: UIButton!
    
    
    //MARK: - переходы
    
    @IBAction func buttonAddNewCategoryAction(_ sender: Any) {
        if textFieldNewCategory.text != "" {
            delegateScreen2Container?.returnDelegateScreen2().returnDelegateScreen1().addCategoryInRealm(newName: textFieldNewCategory.text!, newIcon: "")
        }
        delegateScreen2Container?.screen2ContainerAddNewCategoryCell()
    }
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen2Container: protocolScreen2ContainerDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textFieldNewCategory.layer.cornerRadius = 10
        buttonAddNewCategory.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension Screen2Container_TableViewCellNewCategory: protocolScreen2Container_TableViewCellNewCategory{
    
    func textFieldNewCategoryClear() {
        textFieldNewCategory.text = ""
    }
    
    
}
