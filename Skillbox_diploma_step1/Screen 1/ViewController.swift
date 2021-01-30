//
//  ViewController.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 07.01.2021.
//

import UIKit
import RealmSwift

protocol protocolScreen1Delegate{
    func changeOperationsScope(scope: String)
    func clickToOperation(tag: Int)
    func findAmountOfHeaders()
}

class ViewController: UIViewController {
    
//объявление аутлетов
    @IBOutlet var tableViewScreen1: UITableView!
    @IBOutlet var buttonDaily: UIView!
    @IBOutlet var buttonWeekly: UIView!
    @IBOutlet var buttonMonthly: UIView!
    @IBOutlet var buttonYearly: UIView!
    @IBOutlet var topMenuButtonStrip: UIView!
    @IBOutlet var labelDaily: UILabel!
    @IBOutlet var labelWeekly: UILabel!
    @IBOutlet var labelMothly: UILabel!
    @IBOutlet var labelYearly: UILabel!
    @IBOutlet var bottomPopInList: UIView!
    
    var constantVarOmitIndex: Int = 0
    var specVarOmitIndex: Int = 0
    var date1: Int = 0
    var date2: Int = 0
    
    
//обработка касаний экрана
    @IBAction func buttonDailyGesture(_ sender: Any) {
//        topMenuHighliter(specifyLabel: labelDaily)
        borderForMenuBotton(buttonDaily)
    }
    @IBAction func buttonWeeklyGesture(_ sender: Any) {
//        topMenuHighliter(specifyLabel: labelWeekly)
        borderForMenuBotton(buttonWeekly)
    }
    @IBAction func buttonMonthlyGesture(_ sender: Any) {
//        topMenuHighliter(specifyLabel: labelMothly)
        borderForMenuBotton(buttonMonthly)
    }
    @IBAction func buttonYearlyGesture(_ sender: Any) {
//        topMenuHighliter(specifyLabel: labelYearly)
        borderForMenuBotton(buttonYearly)
    }
    
//Компоновка экрана
    func topMenuHighliter(specifyLabel: UILabel){
        specifyLabel.font = UIFont.systemFont(ofSize: specifyLabel.font.pointSize, weight: .bold)
        switch specifyLabel {
        case labelDaily:
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("111")
        case labelWeekly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("222")
        case labelMothly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("333")
        case labelYearly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            print("444")
        default:
            print("Error with higlightLabel")
        }
    }
    
    func borderForMenuBotton(_ specifyButton: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            switch specifyButton {
            case self.buttonDaily:
                self.topMenuButtonStrip.frame.origin.x = self.buttonDaily.frame.origin.x + 10
            case self.buttonWeekly:
                self.topMenuButtonStrip.frame.origin.x = self.buttonWeekly.frame.origin.x + 10
            case self.buttonMonthly:
                self.topMenuButtonStrip.frame.origin.x = self.buttonMonthly.frame.origin.x + 10
            case self.buttonYearly:
                self.topMenuButtonStrip.frame.origin.x = self.buttonYearly.frame.origin.x + 10
            default:
                print("Error with borderForMenuBotton")
            }
        }, completion: {isCompleted in })
    }
    
//Работа с базой данных
    class Screen1TableData{
        var amount: Double
        var category: String
        var account: String
        var note: String
        var date: Date
        
        init(amount1: Double, category1: String, account1: String, note1: String, date1: Date) {
            self.amount = amount1
            self.category = category1
            self.account = account1
            self.note = note1
            self.date = date1
            
        }
    }
    var newTableDataArray: [Screen1TableData] = []
    
    func screen1TableUpdate(){
        let newTableData = getRealmData()
        for n in newTableData{
            newTableDataArray.append(Screen1TableData(amount1: n.amount, category1: n.category, account1: n.account, note1: n.note, date1: n.date))
        }

        print(newTableData)
        print(newTableData.count)
    }
    
//    -------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//Сохранени данных о времени
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let today = formatter.date(from: "2021/01/19 17:45")
//        let yesterday = formatter.date(from: "2021/01/18 13:15")
//        let a2DaysBefore = formatter.date(from: "2021/01/16 10:05")
//
//        addOperations(amount: 1200, category: "Salary", account: "Debet card", note: "Первая заметка", date: today!)
//        addOperations(amount: -600, category: "Coffee", account: "Cash", note: "Вторая заметка", date: yesterday!)
//        addOperations(amount: -200, category: "Lease payable", account: "Debet card", note: "Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка.", date: a2DaysBefore!)

        
        screen1TableUpdate()
        
//работа с сохранением даты операции
//        let calendar = Calendar.current
//        print(calendar.component(.hour, from: Date()))
        print(Date.init())
        
        bottomPopInList.backgroundColor = .red
        bottomPopInList.layer.cornerRadius  = 20
        bottomPopInList.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Do any additional setup after loading the view.
    }
}

extension ViewController: protocolScreen1Delegate{
    func changeOperationsScope(scope: String) {
        return
    }
    
    func clickToOperation(tag: Int) {
        return
    }
    
    func findAmountOfHeaders() {
        return
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var varCount: Int = 0
        var previousDay: Int = 0
        for x in newTableDataArray {
            if Calendar.current.component(.day, from: x.date) != previousDay{
                varCount = varCount + 1
                previousDay = Calendar.current.component(.day, from: x.date)
            }
        }
        print("varCount= \(varCount)")
        return newTableDataArray.count + varCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.row= \(indexPath.row)")
        if indexPath.row == 0{
            specVarOmitIndex = 1
//            print("indexPath.row= \(indexPath.row)")
        } else if specVarOmitIndex == 0{
//            print("indexPath.row= \(indexPath.row)")
            print("constantVarOmitIndex= \(constantVarOmitIndex)")
            print("spec= \(indexPath.row - constantVarOmitIndex)")
            date1 = Calendar.current.component(.day, from: newTableDataArray[indexPath.row - constantVarOmitIndex].date)
            date2 = Calendar.current.component(.day, from: newTableDataArray[indexPath.row - constantVarOmitIndex - 1].date)
            
            if date1 != date2{
                specVarOmitIndex = 1
            }
        }
        
        if specVarOmitIndex == 1 {
            print("spec3: ---")
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableViewCellHeader
            let formatterPrint = DateFormatter()
            formatterPrint.dateFormat = "d MMMM"
            print("777: \(formatterPrint.string(from: newTableDataArray[indexPath.row - constantVarOmitIndex].date))")
            cell.labelHeaderDate.text = formatterPrint.string(from: newTableDataArray[indexPath.row - constantVarOmitIndex].date)
            constantVarOmitIndex = constantVarOmitIndex + 1
            specVarOmitIndex = 2
            return cell
        }
        else {
            print("spec4: ---")
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "operation") as! Screen1TableViewCellCategory
            cell2.labelCategory.text = newTableDataArray[indexPath.row - constantVarOmitIndex].category
            cell2.labelAmount.text = String(newTableDataArray[indexPath.row - constantVarOmitIndex].amount)
            if newTableDataArray[indexPath.row - constantVarOmitIndex].amount < 0{
                cell2.labelAmount.textColor = UIColor.red
                cell2.currencyStatus.textColor = UIColor.red
            }
            else{
                cell2.labelAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
                cell2.currencyStatus.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
            }
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(changeCategory(_:)))
//            cell.isUserInteractionEnabled = true
//            cell.addGestureRecognizer(gesture)
//            cell.tag = indexPath.row
            specVarOmitIndex = 0
            return cell2
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
