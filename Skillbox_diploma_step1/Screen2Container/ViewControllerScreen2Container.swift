//
//  ViewControllerScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 22.01.2021.
//

import UIKit

protocol protocolScreen2ContainerDelegate {
//    func setTable(_ newStatus: Int)
    func buttonDeleteItemHandler(_ tag: Int)
    func checkBoxStatus(_ tag: Int,_ type: Bool)
    func giveScreen2ContainerMenuArray() -> [Screen2ContainerMenuData]
    func closeWindows(_ tag: Int)
    //функции возврата
    func returnDelegateScreen2() -> protocolScreen2Delegate
    func screen2ContainerAllUpdate()
}

struct Screen2ContainerMenuData {
    let name: String
    let status: Bool
}

class ViewControllerScreen2Container: UIViewController {

    //MARK: - аутлеты
    
    @IBOutlet var tableViewContainer: UITableView!
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen2: protocolScreen2Delegate?
    var delegateScreen2Container_TableViewCellHeader: protocolScreen2Container_TableViewCellHeader?
    var statusEditContainer: Bool = false

    var screen2ContainerMenuArray: [Screen2ContainerMenuData] = []
//    var tableStatus: Int = 0
    
    
    //MARK: - данные
//Здесь будет обработка данных в зависимости от tableStatus
    let screen2ContainerMenuList0 = Screen2ContainerMenuData(name: "Header", status: false)
    let screen2ContainerMenuList1 = Screen2ContainerMenuData(name: "Rental revenue", status: true)
    let screen2ContainerMenuList2 = Screen2ContainerMenuData(name: "Car", status: false)
    let screen2ContainerMenuList3 = Screen2ContainerMenuData(name: "Salary", status: false)
    let screen2ContainerMenuList4 = Screen2ContainerMenuData(name: "Food & Restaurants", status: false)
    let screen2ContainerMenuList5 = Screen2ContainerMenuData(name: "Coffee", status: false)
    let screen2ContainerMenuList6 = Screen2ContainerMenuData(name: "Mobile Account", status: false)
    
    
    //MARK: - viewDidLoad
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
        
        screen2ContainerMenuArray = [screen2ContainerMenuList0, screen2ContainerMenuList1, screen2ContainerMenuList2, screen2ContainerMenuList3, screen2ContainerMenuList4, screen2ContainerMenuList5, screen2ContainerMenuList6]
        
    }
}

//MARK: - additional protocols

extension ViewControllerScreen2Container: protocolScreen2ContainerDelegate {
    
    
    func screen2ContainerAllUpdate() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            
            if self.statusEditContainer == true{
                self.statusEditContainer = false
                self.delegateScreen2Container_TableViewCellHeader?.setButtonOptionsColor(color: UIColor.white)
//                delegateScreen2?.changeCategoyPopUpScreen2Height(status: statusEditContainer)
            }
            else {
                self.statusEditContainer = true
                self.delegateScreen2Container_TableViewCellHeader?.setButtonOptionsColor(color: UIColor.systemBlue)
            }
            
            self.tableViewContainer.reloadData()
            
        }, completion: {isCompleted in })
    }
    
    
    func returnDelegateScreen2() -> protocolScreen2Delegate {
        return delegateScreen2!
    }
    
    func closeWindows(_ tag: Int) {
        delegateScreen2?.changeCategoryClosePopUpScreen2()
        tableViewContainer.reloadData()
        print("ClosePopup from Container")
    }

    func giveScreen2ContainerMenuArray() -> [Screen2ContainerMenuData] {
//        print (screen2ContainerMenuArray)
        return screen2ContainerMenuArray
    }
    
//    func setTable(_ newStatus: Int) {
//        tableStatus = newStatus
//    }
    
    func buttonDeleteItemHandler(_ tag: Int) {
        print("data deleted, \(tag)")
        closeWindows(tag)
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
        return statusEditContainer == true ? screen2ContainerMenuArray.count + 1 : screen2ContainerMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen2Container_TableViewCellHeader
            cell.delegateScreen2Container = self
            delegateScreen2Container_TableViewCellHeader = cell
            return cell
        }
        else if statusEditContainer == true && indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellNewCategory") as! Screen2Container_TableViewCellNewCategory
            cell.delegateScreen2Container = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChangeCategory") as! Screen2Container_TableViewCellChangeCategory
            cell.delegateScreen2Container = self
            cell.setTag(tag: statusEditContainer == true ? indexPath.row - 1 : indexPath.row)
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
