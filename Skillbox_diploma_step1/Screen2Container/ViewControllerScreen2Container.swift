//
//  ViewControllerScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 22.01.2021.
//

import UIKit

protocol protocolScreen2ContainerDelegate {
    func setTable(_ newStatus: Int)
    func buttonDeleteItemHandler(_ tag: Int)
    func checkBoxStatus(_ tag: Int,_ type: Bool)
    func giveScreen2ContainerMenuArray() -> [Screen2ContainerMenuData]
    func closeWindows(_ tag: Int)
}

struct Screen2ContainerMenuData {
    let name: String
    let status: Bool
}

class ViewControllerScreen2Container: UIViewController {

    //MARK: - объявление делигатов
    var delegateScreen2: protocolScreen2Delegate?

    //MARK: - работа с данными на экране
    
    var screen2ContainerMenuArray: [Screen2ContainerMenuData] = []
    var tableStatus: Int = 0
    
//Здесь будет обработка данных в зависимости от tableStatus
    let screen2ContainerMenuList0 = Screen2ContainerMenuData(name: "Header", status: false)
    let screen2ContainerMenuList1 = Screen2ContainerMenuData(name: "Rental revenue", status: true)
    let screen2ContainerMenuList2 = Screen2ContainerMenuData(name: "Car", status: false)
    let screen2ContainerMenuList3 = Screen2ContainerMenuData(name: "Salary", status: false)
    let screen2ContainerMenuList4 = Screen2ContainerMenuData(name: "Food & Restaurants", status: false)
    let screen2ContainerMenuList5 = Screen2ContainerMenuData(name: "Coffee", status: false)
    let screen2ContainerMenuList6 = Screen2ContainerMenuData(name: "Mobile Account", status: false)
    
    //MARK: - обработка касаний
//    @objc func tapHandlerContainerHide(tap: UITapGestureRecognizer){
//        if tap.state == UIGestureRecognizer.State.ended {
//            print("Tap ended")
//            let pointOfTap = tap.location(in: self.view)
//            if self.view.frame.contains(pointOfTap) {
//                print("Tap inside Container")
//            }
//            else {
//                print("Tap beyond Container")
//            }
//        }
//    }
    
    //MARK: - viewDidLoad
    @objc override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer()
//        tap.addTarget(self, action: #selector(tapHandlerContainerHide(tap:)))
//        self.view.addGestureRecognizer(tap)
        
//        tapHandlerContainerHide(tap: <#T##UITapGestureRecognizer#>)
        
        screen2ContainerMenuArray = [screen2ContainerMenuList0, screen2ContainerMenuList1, screen2ContainerMenuList2, screen2ContainerMenuList3, screen2ContainerMenuList4, screen2ContainerMenuList5, screen2ContainerMenuList6]
        
    }
}

//MARK: - extensionProtocol
extension ViewControllerScreen2Container: protocolScreen2ContainerDelegate {
    func closeWindows(_ tag: Int) {
        delegateScreen2?.changeCategoryClosePopUp()
        print("ClosePopup from Container")
    }

    func giveScreen2ContainerMenuArray() -> [Screen2ContainerMenuData] {
//        print (screen2ContainerMenuArray)
        return screen2ContainerMenuArray
    }
    
    func setTable(_ newStatus: Int) {
        tableStatus = newStatus
    }
    
    func buttonDeleteItemHandler(_ tag: Int) {
        print("data deleted, \(tag)")
        closeWindows(tag)
    }
    
    func checkBoxStatus(_ tag: Int, _ type: Bool) {
        print("CheckBoxStatus, \(tag)")
        closeWindows(tag)
    }
}

//MARK: - extensionProtocol
extension ViewControllerScreen2Container: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screen2ContainerMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen2Container_TableViewCellHeader
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChangeCategory") as! Screen2Container_TableViewCellChangeCategory
            cell.delegateScreen2Container = self
            cell.setTag(tag: indexPath.row)
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
