//
//  ViewControllerScreen2.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 16.01.2021.
//

import UIKit

protocol protocolScreen2Delegate{
    func changeCategoryClosePopUp()
    func changeCategoryOpenPopUp(_ tag: Int)
    func getScreen2MenuArray() -> [Screen2MenuData]
}

struct Screen2MenuData {
    let name: String
    let text: String
}

class ViewControllerScreen2: UIViewController {

    //MARK: - объявление Аутлетов
    
    @IBOutlet var screen2SegmentControl: UISegmentedControl!
    @IBOutlet var tableViewScreen2: UITableView!
    @IBOutlet var screen2CurrencyStatus: UIButton!
    @IBOutlet var containerBottom: UIView!
    
    @IBOutlet var constraintContainerBottomPoint: NSLayoutConstraint!
    @IBOutlet var constraintContainerBottomHeight: NSLayoutConstraint!
    
    @IBAction func screen2SegmentControlAction(_ sender: Any) {
        switch screen2SegmentControl.selectedSegmentIndex {
        case 0:
            screen2CurrencyStatus.setTitle("+$", for: .normal)
            screen2CurrencyStatus.setTitleColor(UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1)), for: .normal)
        case 1:
            screen2CurrencyStatus.setTitle("-$", for: .normal)
            screen2CurrencyStatus.setTitleColor(UIColor.red, for: .normal)
        default:
            break
        }
    }
    
    //MARK: - Объявление переменных
//    let darkBlur = UIBlurEffect(style: .light)
    let blurView =  UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    
    //обработка касаний экрана
    @IBAction func areaOutsideHideContainerGesture(_ sender: Any) {
        if self.constraintContainerBottomHeight.constant > 0 {
//            changeCategoryClosePopUp()
        }
    }
    
    @objc func tapHandlerContainerHide(tap: UITapGestureRecognizer){
        if tap.state == UIGestureRecognizer.State.ended {
            print("Tap ended")
            let pointOfTap = tap.location(in: self.view)
            if containerBottom.frame.contains(pointOfTap) {
                print("Tap inside Container")
            }
            else {
                print("Tap beyond Container")
                changeCategoryClosePopUp()
            }
        }
    }
    
    
    //MARK: - данныe на экране
    var screen2MenuArray: [Screen2MenuData] = []
    
    let Screen2MenuList0 = Screen2MenuData(name: "Header", text: "")
    let Screen2MenuList1 = Screen2MenuData(name: "Category", text: "Select category")
    let Screen2MenuList2 = Screen2MenuData(name: "Date", text: "Today")
    let Screen2MenuList3 = Screen2MenuData(name: "Category", text: "Cash")
    let Screen2MenuList4 = Screen2MenuData(name: "Notes", text: "")
    
    //MARK: - переходы между экранами
    var delegateScreen2Container: protocolScreen2ContainerDelegate?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewControllerScreen2Container, segue.identifier == "segueToScreen2Container"{
            delegateScreen2Container = vc
            vc.delegateScreen2 = self
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        screen2MenuArray = [Screen2MenuList0, Screen2MenuList1, Screen2MenuList2, Screen2MenuList3, Screen2MenuList4]
//        containerBottom.layer.zPosition = 1
        self.view.layoutIfNeeded()
        
    }

}

extension ViewControllerScreen2: protocolScreen2Delegate{
    
    //MARK: - окрытие окна changeCategory
    func changeCategoryOpenPopUp(_ tag: Int) {
//        containerBottom.layer.borderWidth = 3
//        containerBottom.layer.borderColor = UIColor.red.cgColor
        self.containerBottom.layer.cornerRadius  = 20
        self.constraintContainerBottomHeight.constant = CGFloat(50*(self.screen2MenuArray.count+2))
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.constraintContainerBottomPoint.constant = 50
            let tap = UITapGestureRecognizer()
            tap.addTarget(self, action: #selector(self.tapHandlerContainerHide(tap:)))
            self.view.addGestureRecognizer(tap)
            
//            self.view.addSubview(self.blurView)
            self.view.insertSubview(self.blurView, belowSubview: self.containerBottom)
//            self.containerBottom.sendSubviewToBack(self.blurView)
            
            self.blurView.backgroundColor = .clear
            self.blurView.translatesAutoresizingMaskIntoConstraints = false
//            self.containerBottom.insertSubview(self.blurView, at: 0)
            
            NSLayoutConstraint.activate([
                self.blurView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.blurView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
                self.blurView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            ])

            
            self.view.layoutIfNeeded()
        }, completion: {isCompleted in })
        
    }
    
    //MARK: - закрытие окна changeCategory
    @objc func changeCategoryClosePopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.constraintContainerBottomPoint.constant = -515
            self.blurView.removeFromSuperview()
            self.view.layoutIfNeeded()
        }, completion: {isCompleted in })
    }
    
    func getScreen2MenuArray() -> [Screen2MenuData] {
        return screen2MenuArray
    }

}

//MARK: - extension
extension ViewControllerScreen2: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screen2MenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen2TableViewCellHeader
            return cell
        }
        else if indexPath.row > 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote") as! Screen2TableViewCellNote
            cell.deligateScreen2 = self
            cell.setTag(tag: indexPath.row)
            cell.startCell()
            
//            cell.textFieldNotes.text = screen2MenuArray[indexPath.row].text
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory") as! Screen2TableViewCellCategory
            cell.deligateScreen2 = self
            cell.setTag(tag: indexPath.row)
            cell.startCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 4 {
            return 200
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
