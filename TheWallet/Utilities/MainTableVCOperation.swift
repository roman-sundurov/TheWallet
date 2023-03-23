//
//  Screen1TableViewCellCategory.swift
//  MoneyManager
//
//  Created by Roman on 26.01.2021.
//

import UIKit

class MainTableVCOperation: UITableViewCell {
    @IBOutlet var viewPictureOfCategory: UIView!
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelAmount: UILabel!
    @IBOutlet var currencyStatus: UILabel!
    
    var vcMainDelegate: ProtocolVCMain?
    var id: UUID?
    
    @objc func showOperation(_ sender: UITapGestureRecognizer) {
        vcMainDelegate?.showOperation(id!)
        print("ChangeCategory from Screen2")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
            // Initialization code
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showOperation(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
