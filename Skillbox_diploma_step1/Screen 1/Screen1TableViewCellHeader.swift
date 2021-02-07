//
//  Screen1TableViewCellHeader.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 26.01.2021.
//

import UIKit

class Screen1TableViewCellHeader: UITableViewCell {
    
    @IBOutlet var labelHeaderDate: UILabel!
    
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
        print("Header1: ---")
        let formatterPrint = DateFormatter()
        formatterPrint.dateFormat = "d MMMM"
        print("111: \(formatterPrint.string(from: deligateScreen1!.getNewTableDataArray()[specCellTag].date))")
        labelHeaderDate.text = formatterPrint.string(from: deligateScreen1!.getNewTableDataArray()[specCellTag].date)
    }
    
    func startCell2() {
        print("Header2: ---")
        let formatterPrint = DateFormatter()
        formatterPrint.dateFormat = "d MMMM"
        let specVar: Int = specCellTag - deligateScreen1!.getArrayForIncrease()[specCellTag - 1]
        print("222: \(formatterPrint.string(from: deligateScreen1!.getNewTableDataArray()[specVar].date))")
        labelHeaderDate.text = formatterPrint.string(from: deligateScreen1!.getNewTableDataArray()[specVar].date)
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }

}
