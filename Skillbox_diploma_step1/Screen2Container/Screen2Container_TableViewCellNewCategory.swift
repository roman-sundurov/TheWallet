//
//  Screen2Container_TableViewCellNewCategory.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 21.04.2021.
//

import UIKit

class Screen2Container_TableViewCellNewCategory: UITableViewCell {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var textFieldNewCategory: UITextField!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen2Container: protocolScreen2ContainerDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
