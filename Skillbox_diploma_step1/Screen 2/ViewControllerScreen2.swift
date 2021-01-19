//
//  ViewControllerScreen2.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 16.01.2021.
//

import UIKit

class ViewControllerScreen2: UIViewController {

    @IBOutlet var tableViewScreen2: UITableView!
    @IBOutlet var ContainerViewScreen2: UIView!
    
    struct menuData {
        let name: String
        let text: String
    }
    
    var menuArray: [menuData] = []
    
    let menuList0 = menuData(name: "Header", text: "")
    let menuList1 = menuData(name: "Category", text: "Select category")
    let menuList2 = menuData(name: "Date", text: "Today")
    let menuList3 = menuData(name: "Category", text: "Cash")
    let menuList4 = menuData(name: "Notes", text: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuArray = [menuList0, menuList1, menuList2, menuList3, menuList4]
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ViewControllerScreen2: UITabBarDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! TableViewCellHeader
            return cell
        }
        else if indexPath.row > 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote") as! TableViewCellNote
            cell.textFieldNotes.text = menuArray[indexPath.row].text
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory") as! TableViewCellCategory
            cell.labelCategory.text = menuArray[indexPath.row].name
            cell.labelSelectCategory.text = menuArray[indexPath.row].text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
