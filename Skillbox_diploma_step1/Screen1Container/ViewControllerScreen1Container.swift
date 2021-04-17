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
}

class ViewControllerScreen1Container: UIViewController{
    
    
    //MARK: - аутлеты
    
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelAmount: UILabel!
    @IBOutlet var currencyStatus: UILabel!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var textViewNotes: UITextView!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen1: protocolScreen1Delegate?

    
    //MARK: - переходы
    
    
    @IBAction func buttonToEditOperation(_ sender: Any) {
    }
    
    
    @IBAction func buttonToDeleteOperation(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
}
