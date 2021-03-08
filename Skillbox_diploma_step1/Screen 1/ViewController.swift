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
    func screen1AllUpdate()
}

class Screen1TableData{
    var amount: Double
    var category: String
    var note: String
    var date: Date
    
    init(amount1: Double, category1: String, note1: String, date1: Date) {
        self.amount = amount1
        self.category = category1
        self.note = note1
        self.date = date1
    }
}

class ViewController: UIViewController {
    
    //MARK: - объявление аутлетов
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
    
    //MARK: - объявление переменных
    
    var newTableDataArrayOriginal: [Screen1TableData] = [] //хранение оригинала данных из Realm
    var newTableDataArray: [Screen1TableData] = [] //хранение модифицированных данных из Realm для конкретного режима отоборажения
    var arrayForIncrease: [Int] = [0] //показывает количество заголовков с новой датой в таблице, которое предшествует конкретной операции
    var daysForSorting: Int = 30
    
    //MARK: - клики по верхнему меню
    
    func changeDaysForSorting(){
        switch daysForSorting {
        case 1:
            print("daysForSorting is 1")
        case 7:
            print("daysForSorting is 7")
        case 30:
            print("daysForSorting is 30")
        case 365:
            print("daysForSorting is 365")
        default:
            print("daysForSorting has not recognized in viewDidLoad")
        }
        borderForMenuBottom(days: daysForSorting)
        screen1TableUpdateSorting(days: daysForSorting)
        daysForSortingRealmUpdate()
    }
    
    @IBAction func buttonDailyGesture(_ sender: Any) {
        daysForSorting = 1
        changeDaysForSorting()
    }
    @IBAction func buttonWeeklyGesture(_ sender: Any) {
        daysForSorting = 7
        changeDaysForSorting()
    }
    @IBAction func buttonMonthlyGesture(_ sender: Any) {
        daysForSorting = 30
        changeDaysForSorting()
    }
    @IBAction func buttonYearlyGesture(_ sender: Any) {
        daysForSorting = 365
        changeDaysForSorting()
    }

    //MARK: - структура верхнего меню
    
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
    
    func borderForMenuBottom(days: Int) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            switch days {
            case 1:
                self.topMenuButtonStrip.frame.origin.x = self.buttonDaily.frame.origin.x + 10
                print("borderForMenuBottom 1")
            case 7:
                self.topMenuButtonStrip.frame.origin.x = self.buttonWeekly.frame.origin.x + 10
                print("borderForMenuBottom 7")
            case 30:
                self.topMenuButtonStrip.frame.origin.x = self.buttonMonthly.frame.origin.x + 10
                print("borderForMenuBottom 30")
            case 365:
                self.topMenuButtonStrip.frame.origin.x = self.buttonYearly.frame.origin.x + 10
                print("borderForMenuBottom 365")
            default:
                print("Error with borderForMenuBotton")
            }
        }, completion: {isCompleted in })
    }
    
    func borderForMenuBottomWhenStart(days: Int) {
        switch days {
        case 1:
            self.topMenuButtonStrip.frame.origin.x = self.buttonDaily.frame.origin.x + 10
            print("borderForMenuBottom 1, when start")
        case 7:
            self.topMenuButtonStrip.frame.origin.x = self.buttonWeekly.frame.origin.x + 10
            print("borderForMenuBottom 7, when start")
        case 30:
            self.topMenuButtonStrip.frame.origin.x = self.buttonMonthly.frame.origin.x + 10
            print("borderForMenuBottom 30, when start")
        case 365:
            self.topMenuButtonStrip.frame.origin.x = self.buttonYearly.frame.origin.x + 10
            print("borderForMenuBottom 365, when start")
        default:
            print("Error with borderForMenuBotton")
        }
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
    }
    
    
    //MARK: - Работа с таблицей
    
    func tableNumberOfRowsInSection() -> Int{
        if newTableDataArray.count == 0 { return 1 }
        arrayForIncrease = [1]
        var previousDay: Int = 0
        var counter: Int = 0
        for x in newTableDataArray {
            if Calendar.current.component(.day, from: x.date) != previousDay{
                if counter == 0 {
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
        return arrayForIncrease.count
    }
    
    // Обновление сортировки
    func screen1TableUpdateSorting(days: Int){
        let newTime = Date() - TimeInterval.init(86400 * days)
        
        newTableDataArray = newTableDataArrayOriginal
        newTableDataArray.sort(by: { $0.date > $1.date })
    
        let temporarilyDate = newTableDataArray.filter { $0.date >= newTime }
        newTableDataArray = temporarilyDate
        self.tableViewScreen1.reloadData()
    }
    
    //MARK: - Работа с базой данных
    
    func screen1DataReceive(){
        newTableDataArrayOriginal = []
        for n in Persistence.shared.getRealmData(){
            newTableDataArrayOriginal.append(Screen1TableData(amount1: n.amount, category1: n.category, note1: n.note, date1: n.date))
        }
        daysForSorting = Persistence.shared.getDaysForSorting()
    }
    
    func daysForSortingRealmUpdate(){
        Persistence.shared.updateDaysForSorting(daysForSorting: daysForSorting)
    }
    
    //MARK: - viewWillAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        print("topMenuButtonStrip.frame.origin.x = \(topMenuButtonStrip.frame.origin.x)")
        //        print("self.buttonWeekly.frame.origin.x = \(self.buttonWeekly.frame.origin.x)")
//                topMenuButtonStrip.frame.origin.x = 60
//                print("topMenuButtonStrip.frame.origin.x = \(topMenuButtonStrip.frame.origin.x)")
        //        print("self.buttonWeekly.frame.origin.x= \(self.buttonWeekly.frame.origin.x)")
        
        
        borderForMenuBottomWhenStart(days: daysForSorting)
        screen1TableUpdateSorting(days: daysForSorting)
        self.view.layoutIfNeeded()
    }
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let today = formatter.date(from: "2021/02/22 17:45")
//        let yesterday = formatter.date(from: "2021/02/23 13:15")
//        let a2DaysBefore = formatter.date(from: "2021/02/24 10:05")
//
//        Persistence.shared.addOperations(amount: 1200, category: "Salary", note: "Первая заметка", date: today!)
//        Persistence.shared.addOperations(amount: -600, category: "Coffee", note: "Вторая заметка", date: yesterday!)
//        Persistence.shared.addOperations(amount: -200, category: "Lease payable", note: "Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка. Третья очень очень большая заметка.", date: a2DaysBefore!)
        
        screen1DataReceive()
        countingIncomesAndExpensive()
        
        bottomPopInList.backgroundColor = .red
        bottomPopInList.layer.cornerRadius  = 20
        bottomPopInList.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Do any additional setup after loading the view.
    }
}
//MARK: - additional protocols

extension ViewController: protocolScreen1Delegate{
    
    func screen1AllUpdate() {
        screen1DataReceive()
        countingIncomesAndExpensive()
        changeDaysForSorting()
    }
    
    
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

//MARK: - table Functionality
extension ViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if newTableDataArray.isEmpty{
//            print("newTableDataArray is empty")
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
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
