//
//  ViewControllerScreen2.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 16.01.2021.
//

import UIKit

//protocol protocolChangeCategory {
//    func changeCategory(tag: Int)
//}

class ViewControllerScreen2: UIViewController {

    @IBOutlet var screen2SegmentControl: UISegmentedControl!
    @IBOutlet var tableViewScreen2: UITableView!
    @IBOutlet var screen2CurrencyStatus: UIButton!
    @IBOutlet var constraintContainerBottom: NSLayoutConstraint!
    
    
    @IBSegueAction func sequeToScreen2Container(_ coder: NSCoder) -> ViewControllerScreen2Container? {
        return <#ViewControllerScreen2Container(coder: coder)#>
    }
    
    @IBAction func screen2SegmentControlAction(_ sender: Any) {
        switch screen2SegmentControl.selectedSegmentIndex {
        case 0:
            print("1")
        case 1:
            screen2CurrencyStatus.titleLabel?.text = "-$"
            screen2CurrencyStatus.titleLabel?.textColor = UIColor.red
            print("2")
        default:
            break
        }
    }
    
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
    
    
    
    @objc func changeCategory(_ tag: Int) {
//        ContainerViewScreen2.aaa? = 8
        constraintContainerBottom.constant = 0
    }

    
    
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

extension ViewControllerScreen2: UITableViewDelegate, UITableViewDataSource{
    
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
            let gesture = UITapGestureRecognizer(target: self, action: #selector(changeCategory(_:)))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(gesture)
            cell.tag = indexPath.row
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
