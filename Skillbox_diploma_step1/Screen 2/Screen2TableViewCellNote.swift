//
//  TableViewCellNote.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 19.01.2021.
//

import UIKit

class Screen2TableViewCellNote: UITableViewCell {

    @IBOutlet var textFieldNotes: UITextField!
    
    var deligateScreen2: protocolScreen2Delegate?
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
        textFieldNotes.text = deligateScreen2?.getScreen2MenuArray()[specCellTag].text
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }
    
}
