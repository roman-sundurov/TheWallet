//
//  ViewControllerScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 22.01.2021.
//

import UIKit

protocol protocolScreen2ContainerDeligate {
    func setTable(_ newStatus: Int)
}

class ViewControllerScreen2Container: UIViewController {

    
    var deligateScreen2: protocolScreen2Deligate?

    //работа с данными на экране
    
    struct Screen2ContainerMenuData {
        let name: String
        let status: Bool
    }
    
    var screen2ContainerMenuArray: [Screen2ContainerMenuData] = []
    var tableStatus: Int = 0
    
    let screen2ContainerMenuList0 = Screen2ContainerMenuData(name: "Header", status: false)
    let screen2ContainerMenuList1 = Screen2ContainerMenuData(name: "Rental revenue", status: true)
    let screen2ContainerMenuList2 = Screen2ContainerMenuData(name: "Car", status: false)
    let screen2ContainerMenuList3 = Screen2ContainerMenuData(name: "Salary", status: false)
    let screen2ContainerMenuList4 = Screen2ContainerMenuData(name: "Food & Restaurants", status: false)
    let screen2ContainerMenuList5 = Screen2ContainerMenuData(name: "Coffee", status: false)
    let screen2ContainerMenuList6 = Screen2ContainerMenuData(name: "Mobile Account", status: false)

    
    @objc func closeWindows() {
        deligateScreen2?.closePopupWindow()
        print("ClosePopup")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen2ContainerMenuArray = [screen2ContainerMenuList0, screen2ContainerMenuList1, screen2ContainerMenuList2, screen2ContainerMenuList3, screen2ContainerMenuList4, screen2ContainerMenuList5, screen2ContainerMenuList6]

    }
}

extension ViewControllerScreen2Container: protocolScreen2ContainerDeligate {
    func setTable(_ newStatus: Int) {
        tableStatus = newStatus
    }
}

extension ViewControllerScreen2Container: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screen2ContainerMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! TableViewCellHeaderScreen2Container
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChangeCategory") as! TableViewCellChangeCategoryScreen2Container
            cell.labelChangeCategory.text = screen2ContainerMenuArray[indexPath.row].name
            let gesture = UITapGestureRecognizer(target: self, action: #selector(closeWindows))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(gesture)
//            cell.tag = indexPath.row
//            deligateScreen2Container?.change_color(UIColor.blue)
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
