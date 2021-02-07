//
//  Screen1TableViewCellCategory.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 26.01.2021.
//

import UIKit

class Screen1TableViewCellCategory: UITableViewCell {

    @IBOutlet var viewPictureOfCategory: UIView!
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelAmount: UILabel!
    @IBOutlet var currencyStatus: UILabel!
    
    var deligateScreen1: protocolScreen1Delegate?
    var specCellTag: Int = 0
    
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
        let specVar: Int = specCellTag - deligateScreen1!.getArrayForIncrease()[specCellTag]
        labelCategory.text = deligateScreen1!.getNewTableDataArray()[specVar].category
        labelAmount.text = String(deligateScreen1!.getNewTableDataArray()[specVar].amount)
        if deligateScreen1!.getNewTableDataArray()[specVar].amount < 0 {
            labelAmount.textColor = UIColor.red
            currencyStatus.textColor = UIColor.red
        }
        else{
            labelAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
            currencyStatus.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
        }
        //            let gesture = UITapGestureRecognizer(target: self, action: #selector(changeCategory(_:)))
        //            cell.isUserInteractionEnabled = true
        //            cell.addGestureRecognizer(gesture)
        //            cell.tag = indexPath.row
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }
}
