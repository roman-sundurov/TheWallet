//
//  ViewControllerScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 22.01.2021.
//

import UIKit

protocol protocolScreen2ContainerDelegate {
    func buttonDeleteCategoryHandler()
    func checkBoxStatus(_ tag: Int,_ type: Bool)
    func closeWindows(_ tag: Int)
    func screen2ContainerAddNewCategoryCell()
    
    //функции возврата
    func returnDelegateScreen2() -> protocolScreen2Delegate
    func returnScreen2StatusEditContainer() -> Bool
    func returnDelegateScreen2Container_TableViewCellNewCategory() -> protocolScreen2Container_TableViewCellNewCategory
}

class ViewControllerScreen2Container: UIViewController {

    //MARK: - объявление аутлетов
    
    @IBOutlet var tableViewContainer: UITableView!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen2: protocolScreen2Delegate?
    var delegateScreen2Container_TableViewCellHeader: protocolScreen2Container_TableViewCellHeader?
    var delegateScreen2Container_TableViewCellNewCategory: protocolScreen2Container_TableViewCellNewCategory?
    var statusEditContainer: Bool = false
    
    
    //MARK: - данные
//Здесь будет обработка данных в зависимости от tableStatus
//    let screen2ContainerMenuList0 = Screen2ContainerMenuData(name: "Header", status: false)
//    let screen2ContainerMenuList1 = Screen2ContainerMenuData(name: "Rental revenue", status: true)
//    let screen2ContainerMenuList2 = Screen2ContainerMenuData(name: "Car", status: false)
//    let screen2ContainerMenuList3 = Screen2ContainerMenuData(name: "Salary", status: false)
//    let screen2ContainerMenuList4 = Screen2ContainerMenuData(name: "Food & Restaurants", status: false)
//    let screen2ContainerMenuList5 = Screen2ContainerMenuData(name: "Coffee", status: false)
//    let screen2ContainerMenuList6 = Screen2ContainerMenuData(name: "Mobile Account", status: false)
    
    
    //MARK: - viewDidLoad
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//MARK: - additional protocols

extension ViewControllerScreen2Container: protocolScreen2ContainerDelegate {
    
    func returnDelegateScreen2Container_TableViewCellNewCategory() -> protocolScreen2Container_TableViewCellNewCategory {
        return delegateScreen2Container_TableViewCellNewCategory!
    }

    
    func returnScreen2StatusEditContainer() -> Bool {
        return statusEditContainer
    }

    
    func screen2ContainerAddNewCategoryCell() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            
            if self.statusEditContainer == true{
                self.statusEditContainer = false
                self.delegateScreen2Container_TableViewCellHeader?.buttonOptionsSetColor(color: UIColor.white)
            }
            else {
                self.statusEditContainer = true
                self.delegateScreen2Container_TableViewCellHeader?.buttonOptionsSetColor(color: UIColor.systemBlue)
            }
            
            self.delegateScreen2!.screen2DataReceiveUpdate()
            self.tableViewContainer.reloadData()
            
        }, completion: {isCompleted in })
    }
    
    
    func returnDelegateScreen2() -> protocolScreen2Delegate {
        return delegateScreen2!
    }
    
    
    func closeWindows(_ tag: Int) {
        delegateScreen2?.changeCategoryClosePopUpScreen2()
        tableViewContainer.reloadData()
        delegateScreen2Container_TableViewCellNewCategory?.textFieldNewCategoryClear()
        print("ClosePopup from Container")
    }

    
    func buttonDeleteCategoryHandler() {
    }
    
    
    func checkBoxStatus(_ tag: Int, _ type: Bool) {
        print("CheckBoxStatus, \(tag)")
        closeWindows(tag)
    }
    
    
}

//MARK: - table Functionality
extension ViewControllerScreen2Container: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if delegateScreen2?.returnDataArrayOfCategory().count == 0{
            statusEditContainer = true
            return 2
        }
        else if statusEditContainer == true{
            return delegateScreen2?.returnDataArrayOfCategory().count as! Int + 2
        }
        else{
            return delegateScreen2?.returnDataArrayOfCategory().count as! Int + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.rowScreen2= \(indexPath.row)")
        if indexPath.row == 0{
            print("1111")
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen2Container_TableViewCellHeader
            cell.delegateScreen2Container = self
            delegateScreen2Container_TableViewCellHeader = cell
            return cell
        }
        else if statusEditContainer == true && indexPath.row == 1{
            print("2222")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellNewCategory") as! Screen2Container_TableViewCellNewCategory
            cell.delegateScreen2Container = self
            delegateScreen2Container_TableViewCellNewCategory = cell
            return cell
        }
        else {
            print("3333")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChangeCategory") as! Screen2Container_TableViewCellChangeCategory
            cell.delegateScreen2Container = self
            cell.setTag(tag: statusEditContainer == true ? indexPath.row - 2 : indexPath.row - 1)
            cell.startCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
