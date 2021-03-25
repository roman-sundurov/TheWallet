//
//  Screen2TableViewCellDate.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 06.03.2021.
//

import UIKit

protocol protocolScreen2TableViewCellDateDelegate{
    func tapOutsideDateTextViewEditToHide()
    func returnDateView() -> UITextField
}

class Screen2TableViewCellDate: UITableViewCell {

    @IBOutlet var labelDate: UILabel!
    @IBOutlet var textFieldSelectDate: UITextField!
    @IBOutlet var buttonSelectDate: UIButton!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen2: protocolScreen2Delegate?
    var specCellTag: Int = 0
    

    //MARK: - переходы
    
//    @IBAction func datePickerSelectDateHandleAction(_ sender: UIDatePicker) {
//        print("Данные в DatePicker изменены")
//        delegateScreen2?.setDateInNewOperation(date: datePickerSelectDate.date)
//    }
//
//    @objc func changeDate(_ tag: Int) {
//        datePickerSelectDate.
//        print("ChangeDate from Screen2")
//    }
//
//    @objc func changeDateOpenDatePicker(_ tag: Int) {
//        datePickerSelectDate.
//        delegateScreen2?.returnDelegateScreen2TableViewCellNote().tapOutsideNoteTextViewEditToHide()
//        delegateScreen2?.changeCategoryOpenPopUp(specCellTag)
//        print("ChangeCategory from table")
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func startCell() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        if delegateScreen2?.returnNewOperation().date != Date.init(timeIntervalSince1970: TimeInterval(0)) {
            textFieldSelectDate.text = dateFormatter.string(from: delegateScreen2!.returnNewOperation().date)
            textFieldSelectDate.textColor = .black
        }
        else{
            textFieldSelectDate.text = delegateScreen2?.getScreen2MenuArray()[specCellTag].text
        }

        textFieldSelectDate.tintColor = UIColor.clear //делает курсор бесцветным, но не убирает его
        labelDate.text = delegateScreen2?.getScreen2MenuArray()[specCellTag].name
        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(gesture)
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }
}

extension Screen2TableViewCellDate: protocolScreen2TableViewCellDateDelegate{
    
    func returnDateView() -> UITextField {
//        tapOutsideNoteTextViewEditToHide()
//        textViewNotes.endEditing(true)
        print("textViewDeselect")
        return textFieldSelectDate
    }

    
    //MARK: - Обработка касаний экрана
    
    func tapOutsideDateTextViewEditToHide(){
        textFieldSelectDate.endEditing(true)
//        delegateScreen2?.setDateInNewOperation(date: <#T##Date#>)
        print("textFieldSelectDateDeselect")
    }
}
