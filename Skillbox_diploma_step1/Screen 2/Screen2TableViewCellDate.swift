//
//  Screen2TableViewCellDate.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 06.03.2021.
//

import UIKit

class Screen2TableViewCellDate: UITableViewCell {

    @IBOutlet var labelDate: UILabel!
//    @IBOutlet var labelSelectDate: UILabel!
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
//        delegateScreen2?.returnDelegateScreen2TableViewCellNote().tapOutsideTextViewEditToHide()
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
