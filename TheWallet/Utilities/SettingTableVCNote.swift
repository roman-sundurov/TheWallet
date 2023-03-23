//
//  SettingTableVCNote.swift
//  MoneyManager
//
//  Created by Roman on 19.01.2021.
//

import UIKit

protocol ProtocolSettingTableVCNote {
    func tapOutsideNoteTextViewEditToHide()
    func returnNoteView() -> UITextView
    func setNoteViewText(newText: String)
}

class SettingTableVCNote: UITableViewCell, UITextViewDelegate {
    @IBOutlet var textViewNotes: UITextView!
    var vcSettingDelegate: ProtocolVCSetting?
    var indexRow: Int = 0

        // MARK: - Working with Placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewNotes.textColor == UIColor.opaqueSeparator {
            textViewNotes.text = nil
            textViewNotes.textColor = UIColor.black
        }
        print("func textViewDidBeginEditing")
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewNotes.text.isEmpty {
            textViewNotes.text = "Placeholder"
            textViewNotes.textColor = UIColor.opaqueSeparator
        }
        textView.resignFirstResponder()
        print("func textViewDidEndEditing")
    }

        // MARK: - standard functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func startCell(indexRow: Int) {
        self.indexRow = indexRow
        textViewNotes.textContainer.lineBreakMode = .byTruncatingTail
        textViewNotes.layer.borderColor = UIColor.gray.cgColor
        textViewNotes.layer.borderWidth = 2
        textViewNotes.layer.cornerRadius = 10
        textViewNotes.text = "Placeholder"
    }
}

extension SettingTableVCNote: ProtocolSettingTableVCNote {
    func setNoteViewText(newText: String) {
        textViewNotes.text = newText
        print("newText= \(newText)")
        textViewNotes.textColor = UIColor.black
    }

    func returnNoteView() -> UITextView {
        tapOutsideNoteTextViewEditToHide()
        textViewNotes.endEditing(true)
        print("textViewDeselect")
        return textViewNotes
    }

        // MARK: - Обработка касаний экрана
    func tapOutsideNoteTextViewEditToHide() {
        textViewNotes.endEditing(true)
        print("textViewDeselect")
    }
}
