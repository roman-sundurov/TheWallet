//
//  ViewControllerScreen1Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 17.04.2021.
//

import UIKit

protocol protocolScreen1ContainerDelegate{
    func buttonEditOperationHandler(_ tag: Int)
    func buttonDeleteOperationHandler(_ tag: Int)
    func startCell(tag: Int)
}

class ViewControllerScreen1Container: UIViewController{
    
    
    //MARK: - аутлеты
    
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelAmount: UILabel!
    @IBOutlet var currencyStatus: UILabel!
    @IBOutlet var textViewNotes: UITextView!
    @IBOutlet var viewRightParth: UIView!
    @IBOutlet var buttonToEditOperation: UIButton!
    @IBOutlet var buttonToDeleteOperation: UIButton!
    @IBOutlet var viewLogoCategory: UIView!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen1: protocolScreen1Delegate?
    
    var newTableDataArray: [Screen1TableData] = []

    
    //MARK: - переходы
    
    
    @IBAction func buttonActionToEditOperation(_ sender: Any) {
    }
    
    
    @IBAction func buttonActionToDeleteOperation(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewNotes.layer.cornerRadius = 10
        viewRightParth.layer.cornerRadius = 10
        buttonToEditOperation.layer.cornerRadius = 10
        buttonToDeleteOperation.layer.cornerRadius = 10
        viewLogoCategory.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }

    
}

extension ViewControllerScreen1Container: protocolScreen1ContainerDelegate{
    func buttonEditOperationHandler(_ tag: Int) {
        return
    }
    
    func buttonDeleteOperationHandler(_ tag: Int) {
        return
    }
    
    
    func startCell(tag: Int) {
        
        print(tag)
        print(delegateScreen1!.getArrayForIncrease()[tag])
        let specVar: Int = tag - delegateScreen1!.getArrayForIncrease()[tag]
        
        //Отображения category
        labelCategory.text = delegateScreen1!.getNewTableDataArray()[specVar].category

        // Отображения date
        let formatterPrint = DateFormatter()
        formatterPrint.dateFormat = "d MMMM YYYY"
        labelDate.text = formatterPrint.string(from: delegateScreen1!.getNewTableDataArray()[specVar].date)
        
        // Отображения amount
        if delegateScreen1!.getNewTableDataArray()[specVar].amount.truncatingRemainder(dividingBy: 1) == 0 {
            labelAmount.text = String(format: "%.0f", delegateScreen1!.getNewTableDataArray()[specVar].amount)
        }
        else {
            labelAmount.text = String(format: "%.2f", delegateScreen1!.getNewTableDataArray()[specVar].amount)
        }
        
        // Отображения currencyStatus
        if delegateScreen1!.getNewTableDataArray()[specVar].amount < 0 {
            labelAmount.textColor = UIColor.red
            currencyStatus.textColor = UIColor.red
        }
        else{
            labelAmount.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
            currencyStatus.textColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
        }
        
        //Отображение textViewNotes
        textViewNotes.text = delegateScreen1!.getNewTableDataArray()[specVar].note
    }
    
    
}
