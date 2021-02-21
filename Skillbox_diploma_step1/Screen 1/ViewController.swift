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
    func getNewTableDataArray() -> [Screen1TableData]
    func getArrayForIncrease() -> [Int]
}

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
    @IBOutlet var labelAmountOfIncome: UILabel!
    @IBOutlet var labelAmountOfExpenses: UILabel!
    
    
//обработка касаний экрана
    @IBAction func buttonDailyGesture(_ sender: Any) {
//        topMenuHighliter(specifyLabel: labelDaily)
        borderForMenuBotton(buttonDaily)
        screen1TableUpdateSorting(days: 1)
    }
    @IBAction func buttonWeeklyGesture(_ sender: Any) {
//        topMenuHighliter(specifyLabel: labelWeekly)
        borderForMenuBotton(buttonWeekly)
        screen1TableUpdateSorting(days: 7)
    }
    @IBAction func buttonMonthlyGesture(_ sender: Any) {
//        topMenuHighliter(specifyLabel: labelMothly)
        borderForMenuBotton(buttonMonthly)
        screen1TableUpdateSorting(days: 30)
    }
    @IBAction func buttonYearlyGesture(_ sender: Any) {
//        topMenuHighliter(specifyLabel: labelYearly)
        borderForMenuBotton(buttonYearly)
        screen1TableUpdateSorting(days: 365)
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
    
    func countingIncomesAndExpensive() {
        var income: Double = 0
        var expensive: Double = 0
        for n in newTableDataArray.filter( { $0.amount > 0 } ) {
            income += n.amount
        }
        for n in newTableDataArray.filter( { $0.amount < 0 } ) {
            expensive += n.amount
        }
        
        if income.truncatingRemainder(dividingBy: 1) == 0 {
            labelAmountOfIncome.text = "$\(String(format: "%.0f", income))"
        }
        else {
            labelAmountOfIncome.text = "$\(String(format: "%.2f", income))"
        }
        if expensive.truncatingRemainder(dividingBy: 1) == 0 {
            labelAmountOfExpenses.text = "$\(String(format: "%.0f", expensive))"
        }
        else {
            labelAmountOfExpenses.text = "$\(String(format: "%.2f", expensive))"
        }


//        labelAmountOfIncome.text = String(format: "%.0f", income)
//        labelAmountOfExpenses.text = String(format: "%.0f", expensive)
    }
    
    
// Работа с таблицей и базой данных
    var date1: Int = 0
    var date2: Int = 0
    var arrayForIncrease: [Int] = [0]
    
    func tableNumberOfRowsInSection() -> Int{
        if newTableDataArray.count == 0 { return 1 }
        arrayForIncrease = [1]
        var previousDay: Int = 0
        var counter: Int = 0
        for x in newTableDataArray {
            if Calendar.current.component(.day, from: x.date) != previousDay{
                if counter == 0 {
//                    arrayForIncrease.append(arrayForIncrease.last!)
//                    arrayForIncrease.append(arrayForIncrease.last! + 1)
                }
                else{
                    arrayForIncrease.append(arrayForIncrease.last!)
                    arrayForIncrease.append(arrayForIncrease.last! + 1)
                }
                previousDay = Calendar.current.component(.day, from: x.date)
            }
            else {
                arrayForIncrease.append(arrayForIncrease.last!)
            }
            counter += 1
        }
        arrayForIncrease.append(arrayForIncrease.last!)
//        print("max inrease= \(arrayForIncrease.last!)")
//        print("arrayForIncrease= \(arrayForIncrease)")
//        print("newTableDataArray.count= \(newTableDataArray.count)")
        return arrayForIncrease.count
    }
    
    var newTableDataArrayOriginal: [Screen1TableData] = []
    var newTableDataArray: [Screen1TableData] = []
    
    func screen1TableUpdate(){
        newTableDataArrayOriginal = []
        for n in Persistence.shared.getRealmData(){
            newTableDataArrayOriginal.append(Screen1TableData(amount1: n.amount, category1: n.category, account1: n.account, note1: n.note, date1: n.date))
            print("DataSpec\(String(describing: newTableDataArrayOriginal.last?.date))")
        }
    }
    
    func screen1TableUpdateSorting(days: Int){
        let newTime = Date() - TimeInterval.init(86400 * days)
        print("newTime= \(newTime)")
        
//        let gregorian = Calendar(identifier: .gregorian)
//        let today = gregorian.date(from: gregorian.dateComponents([.day], from: NSDate() as Date))
//        print("today= \(today)")
//        gregorian.date(byAdding: .day, value: -dateAfter, to: today!)
//        print("gregorian= \(gregorian.dateComponents([.day], from: today!))")
        
//        print("A1: \(newTableDataArray)")
//        for n in newTableDataArray {
//            print("A1: \(n.date)")
//            if n.date >= newTime {
//                print("Bolshe")
//            }
//        }
        
        newTableDataArray = newTableDataArrayOriginal
        newTableDataArray.sort(by: { $0.date > $1.date })
        print("newTableDataArray.count: \(newTableDataArray.count)")
    
        let temporarilyDate = newTableDataArray.filter { $0.date >= newTime }
        newTableDataArray = temporarilyDate
        print("A2: \(newTableDataArray)")
        self.tableViewScreen1.reloadData()
    }
    
//    -------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//Сохранени данных о времени
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let today = formatter.date(from: "2021/02/10 17:45")
//        let yesterday = formatter.date(from: "2021/02/11 13:15")
//        let a2DaysBefore = formatter.date(from: "2021/02/15 10:05")
////////
//        Persistence.shared.addOperations(amount: 1200, category: "Salary", account: "Debet card", note: "Первая заметка", date: today!)
//        Persistence.shared.addOperations(amount: -600, category: "Coffee", account: "Cash", note: "Вторая заметка", date: yesterday!)
//        Persistence.shared.addOperations(amount: -200, category: "Lease payable", account: "Debet card", note: "Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка.", date: a2DaysBefore!)

        
        screen1TableUpdate()
//        borderForMenuBotton(buttonYearly)
        screen1TableUpdateSorting(days: 30)
        countingIncomesAndExpensive()
        
//работа с сохранением даты операции
//        let calendar = Calendar.current
//        print(calendar.component(.hour, from: Date()))
//        print(Date.init())
        
        bottomPopInList.backgroundColor = .red
        bottomPopInList.layer.cornerRadius  = 20
        bottomPopInList.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Do any additional setup after loading the view.
    }
}

extension ViewController: protocolScreen1Delegate{
    
    func getArrayForIncrease() -> [Int]{
        return arrayForIncrease
    }
    
    func getNewTableDataArray() -> [Screen1TableData] {
        return newTableDataArray
    }
    
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
        return tableNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("indexPath.row= \(indexPath.row)")
//        print("arrayForIncrease[indexPath.row]= \(arrayForIncrease[indexPath.row])")
        if newTableDataArray.isEmpty{
            print("newTableDataArray is empty")
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableViewCellHeader
            cell.deligateScreen1 = self
            cell.startCellEmpty()
            return cell

        }
        else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableViewCellHeader
                cell.deligateScreen1 = self
                cell.setTag(tag: indexPath.row)
                cell.startCell()
                return cell
            }
            else if arrayForIncrease[indexPath.row] != arrayForIncrease[indexPath.row - 1] {
                let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableViewCellHeader
                cell.deligateScreen1 = self
                cell.setTag(tag: indexPath.row)
                cell.startCell2()
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "operation") as! Screen1TableViewCellCategory
                cell.deligateScreen1 = self
                cell.setTag(tag: indexPath.row)
                cell.startCell()
                return cell
            }
        }
        
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(changeCategoryOpenPopUp(_:)))
//            cell.isUserInteractionEnabled = true
//            cell.addGestureRecognizer(gesture)
//            cell.tag = indexPath.row

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
