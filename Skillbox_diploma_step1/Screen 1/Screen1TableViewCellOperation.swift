//
//  Screen1TableViewCellCategory.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 26.01.2021.
//

import UIKit

class Screen1TableViewCellOperation: UITableViewCell {

    @IBOutlet var viewPictureOfCategory: UIView!
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelAmount: UILabel!
    @IBOutlet var currencyStatus: UILabel!
    
    var delegateScreen1: protocolScreen1Delegate?
    var specCellTag: Int = 0
    
//Анимация
    @objc func actionsOperationsOpenPopUpScreen1(_ tag: Int) {
        delegateScreen1?.actionsOperationsOpenPopUpScreen1(specCellTag)
        print("ChangeCategory from Screen2")
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
        print("Simple Cell: ---")
        let specVar: Int = specCellTag - delegateScreen1!.getArrayForIncrease()[specCellTag]
        labelCategory.text = delegateScreen1!.getNewTableDataArray()[specVar].category
//        print("aaa: \(delegateScreen1!.getNewTableDataArray()[specVar].amount.truncatingRemainder(dividingBy: 1))")
        if delegateScreen1!.getNewTableDataArray()[specVar].amount.truncatingRemainder(dividingBy: 1) == 0 {
            labelAmount.text = String(format: "%.0f", delegateScreen1!.getNewTableDataArray()[specVar].amount)
        }
        else {
            labelAmount.text = String(format: "%.2f", delegateScreen1!.getNewTableDataArray()[specVar].amount)
        }
        if delegateScreen1!.getNewTableDataArray()[specVar].amount < 0 {
            labelAmount.textColor = UIColor.red
            currencyStatus.textColor = UIColor.red
        }
        else{
            labelAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
            currencyStatus.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionsOperationsOpenPopUpScreen1(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }
}
