//
//  ViewController.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 07.01.2021.
//


//Add for Test_Brunch_2 second time.

import UIKit
import RealmSwift

protocol protocolScreen1Delegate{
    func changeOperationsScope(scope: String)
    func clickToOperation(tag: Int)
    func findAmountOfHeaders()
    func getNewTableDataArray() -> [Screen1TableData]
    func getArrayForIncrease() -> [Int]
    func screen1AllUpdate()
    func addOperationInRealm(newAmount: Double, newCategory: String, newNote: String, newDate: Date)
    func actionsOperationsOpenPopUpScreen1(_ tag: Int)
    func actionsOperationsClosePopUpScreen1()
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
    @IBOutlet var constraintTopMenuBottomStrip: NSLayoutConstraint!
    @IBOutlet var containerBottomScreen1: UIView!
    @IBOutlet var constraintContainerBottomPoint: NSLayoutConstraint!
    
    
    //MARK: - делегаты и переменные
    
    
    var tapOfActionsOperationsOpenPopUpScreen1: UITapGestureRecognizer?
    var delegateScreen2: protocolScreen2Delegate?
    var delegateScreen1Container: protocolScreen1ContainerDelegate?
    
    var newTableDataArrayOriginal: [Screen1TableData] = [] //хранение оригинала данных из Realm
    var newTableDataArray: [Screen1TableData] = [] //хранение модифицированных данных из Realm для конкретного режима отоборажения
    var arrayForIncrease: [Int] = [0] //показывает количество заголовков с новой датой в таблице, которое предшествует конкретной операции
    var daysForSorting: Int = 30
    
    
    //MARK: - объекты
    
    
    let blurViewScreen1 =  UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    //MARK: - переходы
    
    
    @IBAction func buttonToScreen2(_ sender: Any) {
        performSegue(withIdentifier: "segueToScreen2", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewControllerScreen2, segue.identifier == "segueToScreen2" {
            delegateScreen2 = vc
            vc.delegateScreen1 = self
        }
        
        if let vc = segue.destination as? ViewControllerScreen1Container, segue.identifier == "segueToScreen1Container"{
            delegateScreen1Container = vc
            vc.delegateScreen1 = self
        }
    }
    
    
    //MARK: - клики
    
    
    func changeDaysForSorting(){
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
    
    
    @objc func handlerToHideContainerScreen1(tap: UITapGestureRecognizer){
        if tap.state == UIGestureRecognizer.State.ended {
            print("Tap ended")
            let pointOfTap = tap.location(in: self.view)
            if containerBottomScreen1.frame.contains(pointOfTap) {
                print("Tap inside Container")
            }
            else {
                print("Tap outside Container")
                actionsOperationsClosePopUpScreen1()
            }
        }
    }
    

    //MARK: - верхнее меню
    
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
                self.constraintTopMenuBottomStrip.constant = self.buttonDaily.frame.origin.x + 10
                print("borderForMenuBottom 1")
            case 7:
                self.constraintTopMenuBottomStrip.constant = self.buttonWeekly.frame.origin.x + 10
                print("borderForMenuBottom 7")
            case 30:
                self.constraintTopMenuBottomStrip.constant = self.buttonMonthly.frame.origin.x + 10
                print("borderForMenuBottom 30")
            case 365:
                self.constraintTopMenuBottomStrip.constant = self.buttonYearly.frame.origin.x + 10
                print("borderForMenuBottom 365")
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
    }
    
    
    //MARK: - нижнее меню
    
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
    
    
    //MARK: - данные
    
    func screen1DataReceive(){
        newTableDataArrayOriginal = []
        for n in Persistence.shared.getRealmData(){
            newTableDataArrayOriginal.append(Screen1TableData(amount1: n.amount, category1: n.category, note1: n.note, date1: n.date))
        }
        daysForSorting = Persistence.shared.getDaysForSorting()
        print("daysForSorting in screen1DataReceive= \(Persistence.shared.getDaysForSorting())")
        print("newTableDataArrayOriginal= \(newTableDataArrayOriginal)")
    }
    
    func daysForSortingRealmUpdate(){
        Persistence.shared.updateDaysForSorting(daysForSorting: daysForSorting)
    }
    
    
    //MARK: - viewWillAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        borderForMenuBottom(days: daysForSorting)
        screen1TableUpdateSorting(days: daysForSorting)
        self.view.layoutIfNeeded()
    }
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen1AllUpdate()
        
        bottomPopInList.backgroundColor = .red
        bottomPopInList.layer.cornerRadius = 20
        bottomPopInList.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.view.insertSubview(self.blurViewScreen1, belowSubview: self.containerBottomScreen1)
        self.blurViewScreen1.backgroundColor = .clear
        self.blurViewScreen1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.blurViewScreen1.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.blurViewScreen1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.blurViewScreen1.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            self.blurViewScreen1.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        self.blurViewScreen1.isHidden = true
        
        self.view.layoutIfNeeded()
        
    }
}


//MARK: - additional protocols

extension ViewController: protocolScreen1Delegate{
    
    func addOperationInRealm(newAmount: Double, newCategory: String, newNote: String, newDate: Date) {
        print("addOperationInRealm1")
        Persistence.shared.addOperations(amount: newAmount, category: newCategory, note: newNote, date: newDate)
        print("addOperationInRealm2")
    }
    
    func screen1AllUpdate() {
        screen1DataReceive()
        screen1TableUpdateSorting(days: daysForSorting)
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
    
    //MARK: - окрытие PopUp-окна
    
    func actionsOperationsOpenPopUpScreen1(_ tag: Int) {
        containerBottomScreen1.layer.cornerRadius = 20
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.constraintContainerBottomPoint.constant = 50
            self.tapOfActionsOperationsOpenPopUpScreen1 = UITapGestureRecognizer(target: self, action: #selector(self.handlerToHideContainerScreen1(tap:)))
            self.view.addGestureRecognizer(self.tapOfActionsOperationsOpenPopUpScreen1!)
            self.blurViewScreen1.isHidden = false
            self.view.layoutIfNeeded()
        }, completion: {isCompleted in })
    }
    
    
    //MARK: - закрытие PopUp-окна
    
    func actionsOperationsClosePopUpScreen1() {
//        tableViewScreen2Update(row: 1)
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.constraintContainerBottomPoint.constant = -224
            self.blurViewScreen1.isHidden = true
            self.view.removeGestureRecognizer(self.tapOfActionsOperationsOpenPopUpScreen1!)
            self.view.layoutIfNeeded()
        }, completion: {isCompleted in })
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
            cell.delegateScreen1 = self
            cell.startCellEmpty()
            return cell

        }
        else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableViewCellHeader
                cell.delegateScreen1 = self
                cell.setTag(tag: indexPath.row)
                cell.startCell()
                return cell
            }
            else if arrayForIncrease[indexPath.row] != arrayForIncrease[indexPath.row - 1] {
                let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen1TableViewCellHeader
                cell.delegateScreen1 = self
                cell.setTag(tag: indexPath.row)
                cell.startCell2()
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "operation") as! Screen1TableViewCellOperation
                cell.delegateScreen1 = self
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
