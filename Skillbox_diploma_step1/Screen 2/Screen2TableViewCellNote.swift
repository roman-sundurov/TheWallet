//
//  TableViewCellNote.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 19.01.2021.
//

import UIKit

protocol protocolScreen2TextViewEditing {
    func textViewDidBeginEditing()
    func textViewDidEndEditing()
}

class Screen2TableViewCellNote: UITableViewCell {

//    @IBOutlet var textFieldNotes: UITextField!
    @IBOutlet var textViewNotes: UITextView!
    
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
        textViewNotes.text = deligateScreen2?.getScreen2MenuArray()[specCellTag].text
        
        textViewNotes.textContainer.lineBreakMode = .byTruncatingTail
        textViewNotes.layer.borderColor = UIColor.gray.cgColor
        textViewNotes.layer.borderWidth = 2
        
        textViewNotes.layer.cornerRadius  = 10
        
        textViewNotes.text = "Placeholder"
        textViewNotes.textColor = UIColor.lightGray

    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }
}

extension Screen2TableViewCellNote: protocolScreen2TextViewEditing {
    func textViewDidBeginEditing() {
        if textViewNotes.textColor == UIColor.lightGray {
            textViewNotes.text = nil
            textViewNotes.textColor = UIColor.black
        }
        print("func textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing() {
        if textViewNotes.text.isEmpty {
            textViewNotes.text = "Placeholder"
            textViewNotes.textColor = UIColor.lightGray
        }
        print("func textViewDidEndEditing")
    }

}
