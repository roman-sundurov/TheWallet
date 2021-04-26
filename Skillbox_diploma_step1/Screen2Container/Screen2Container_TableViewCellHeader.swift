
//  TableViewCellHeaderScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 23.01.2021.
//

import UIKit

protocol protocolScreen2Container_TableViewCellHeader{
    func buttonOptionsSetColor(color: UIColor)
}

class Screen2Container_TableViewCellHeader: UITableViewCell {

    
    //MARK: - аутлеты
    
    @IBOutlet var buttonOptions: UIButton!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen2Container: protocolScreen2ContainerDelegate?
    
    
    //MARK: - переходы
    
    @IBAction func buttonOptionsAction(_ sender: Any) {
        delegateScreen2Container?.screen2ContainerNewCategorySwicher()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension Screen2Container_TableViewCellHeader: protocolScreen2Container_TableViewCellHeader{
    
    func buttonOptionsSetColor(color: UIColor) {
        buttonOptions.tintColor = color
    }
    
}
