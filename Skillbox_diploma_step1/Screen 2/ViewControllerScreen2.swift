//
//  ViewControllerScreen2.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 16.01.2021.
//

import UIKit

protocol protocolScreen2Deligate {
    func closePopupWindow()
}

class ViewControllerScreen2: UIViewController {

    //объявление Аутлетов
    
    @IBOutlet var screen2SegmentControl: UISegmentedControl!
    @IBOutlet var tableViewScreen2: UITableView!
    @IBOutlet var screen2CurrencyStatus: UIButton!
    @IBOutlet var constraintContainerBottomPoint: NSLayoutConstraint!
    @IBOutlet var constraintContainerBottomHeight: NSLayoutConstraint!
    
    @IBOutlet var conteinerBottom: UIView!
    
    @IBAction func screen2SegmentControlAction(_ sender: Any) {
        switch screen2SegmentControl.selectedSegmentIndex {
        case 0:
            print("1")
        case 1:
            screen2CurrencyStatus.titleLabel?.text = "-$"
            screen2CurrencyStatus.titleLabel?.textColor = UIColor.red
            print("2")
        default:
            break
        }
    }
    
    //работа с данными на экране
    
    struct Screen2MenuData {
        let name: String
        let text: String
    }
    
    var screen2MenuArray: [Screen2MenuData] = []
    
    let Screen2MenuList0 = Screen2MenuData(name: "Header", text: "")
    let Screen2MenuList1 = Screen2MenuData(name: "Category", text: "Select category")
    let Screen2MenuList2 = Screen2MenuData(name: "Date", text: "Today")
    let Screen2MenuList3 = Screen2MenuData(name: "Category", text: "Cash")
    let Screen2MenuList4 = Screen2MenuData(name: "Notes", text: "")
    
    //рабта с переходом между экранами
    var deligateScreen2Container: protocolScreen2ContainerDeligate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewControllerScreen2Container, segue.identifier == "segueToScreen2Container"{
            deligateScreen2Container = vc
            vc.deligateScreen2 = self
        }
    }
    
    @objc func changeCategory(_ tag: Int) {
//        conteinerBottom.layer.borderWidth = 3
//        conteinerBottom.layer.borderColor = UIColor.red.cgColor
        self.conteinerBottom.layer.cornerRadius  = 20
        self.constraintContainerBottomHeight.constant = CGFloat(50*(self.screen2MenuArray.count+2))
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.constraintContainerBottomPoint.constant = 50
        }, completion: {isCompleted in })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen2MenuArray = [Screen2MenuList0, Screen2MenuList1, Screen2MenuList2, Screen2MenuList3, Screen2MenuList4]
        
    }
}

extension ViewControllerScreen2: protocolScreen2Deligate{
    //закрытие окна
    @objc func closePopupWindow() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.constraintContainerBottomPoint.constant = -515
        }, completion: {isCompleted in })
    }
}

extension ViewControllerScreen2: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screen2MenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! TableViewCellHeader
            return cell
        }
        else if indexPath.row > 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote") as! TableViewCellNote
            cell.textFieldNotes.text = screen2MenuArray[indexPath.row].text
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory") as! TableViewCellCategory
            cell.labelCategory.text = screen2MenuArray[indexPath.row].name
            cell.labelSelectCategory.text = screen2MenuArray[indexPath.row].text
            let gesture = UITapGestureRecognizer(target: self, action: #selector(changeCategory(_:)))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(gesture)
            cell.tag = indexPath.row
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 4 {
            return 200
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
