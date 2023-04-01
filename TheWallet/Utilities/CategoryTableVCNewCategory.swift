//
//  CategoryTableVCNewCategory.swift
//  MoneyManager
//
//  Created by Roman on 21.04.2021.
//

import UIKit

protocol ProtocolCategoryTableVCNewCategory {
    func textFieldNewCategoryClear()
}

final class CategoryTableVCNewCategory: UITableViewCell {
        // MARK: - outlets
    @IBOutlet var textFieldNewCategory: UITextField!
    @IBOutlet var buttonAddNewCategory: UIButton!

        // MARK: - transitions
    @IBAction func buttonAddNewCategoryAction(_ sender: Any) {
        if let textFieldNewCategoryText = textFieldNewCategory.text,
           !textFieldNewCategoryText.isEmpty {
            print("111getUserData().categories= \(try? dataManager.getUserData().categories.description)")
            vcCategoryDelegate?.addNewCategory(
                name: textFieldNewCategoryText,
                icon: "",
                date: Date().timeIntervalSince1970
            )
            textFieldNewCategoryClear()
            textFieldNewCategory.endEditing(true)
        } else {
            vcCategoryDelegate?.showAlertErrorAddNewCategory()
        }
    }

        // MARK: - delegates and variables
    var vcCategoryDelegate: ProtocolVCCategory?
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldNewCategory.layer.cornerRadius = 10
        buttonAddNewCategory.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CategoryTableVCNewCategory: ProtocolCategoryTableVCNewCategory {
    func textFieldNewCategoryClear() {
        textFieldNewCategory.text = ""
    }
}
