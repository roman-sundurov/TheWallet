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

class ViewControllerScreen2: UIViewController, UITextViewDelegate {

    //MARK: - объявление Аутлетов и Функций
    
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
    
    //MARK: - Делегаты и объекты
    
    var tapOfChangeCategoryOpenPopUp: UITapGestureRecognizer?
    var tapOutsideTextViewToGoFromTextView: UITapGestureRecognizer?
    
    let blurView =  UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var delegateScreen2TableViewCellNote: protocolScreen2TableViewCellNoteDelegate?
    
    //MARK: - Обработка касаний экрана
    
    @objc func handlerOutsideTextViewToGoFrom(tap: UITapGestureRecognizer){
        if tap.state == UIGestureRecognizer.State.ended {
                print("Tap TextView ended")
            let pointOfTap = tap.location(in: self.view)
            if delegateScreen2TableViewCellNote!.returnView().frame.contains(pointOfTap) {
                print("Tap outside TextView")
                delegateScreen2TableViewCellNote!.tapOutsideTextViewEditToHide()
            }
            else {
                print("Tap inside TextView")
            }
        }
    }
    
    @objc func handlerToHideContainer(tap: UITapGestureRecognizer){
        if tap.state == UIGestureRecognizer.State.ended {
            print("Tap ended")
            let pointOfTap = tap.location(in: self.view)
            if containerBottom.frame.contains(pointOfTap) {
                print("Tap inside Container")
            }
            else {
                print("Tap outside Container")
                changeCategoryClosePopUp()
            }
        }
    }
    
    
    //MARK: - данныe на экране
    var screen2MenuArray: [Screen2MenuData] = []
    
    let Screen2MenuList0 = Screen2MenuData(name: "Header", text: "")
    let Screen2MenuList1 = Screen2MenuData(name: "Category", text: "Select category")
    let Screen2MenuList2 = Screen2MenuData(name: "Date", text: "Today")
    let Screen2MenuList3 = Screen2MenuData(name: "Notes", text: "")
    
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
        screen2MenuArray = [Screen2MenuList0, Screen2MenuList1, Screen2MenuList2, Screen2MenuList3]
        
        self.view.insertSubview(self.blurView, belowSubview: self.containerBottom)
        self.blurView.backgroundColor = .clear
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.blurView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.blurView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            self.blurView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        self.blurView.isHidden = true
        
        self.view.layoutIfNeeded()
        print("screen2MenuArray.count: \(screen2MenuArray.count)")
        
        self.tapOutsideTextViewToGoFromTextView = UITapGestureRecognizer()
        self.tapOutsideTextViewToGoFromTextView!.addTarget(self, action: #selector(self.handlerOutsideTextViewToGoFrom(tap:)))
        self.view.addGestureRecognizer(self.tapOutsideTextViewToGoFromTextView!)

    }

}

extension ViewControllerScreen2: protocolScreen2Delegate{
    
    //MARK: - окрытие окна changeCategory
    func changeCategoryOpenPopUp(_ tag: Int) {
//        containerBottom.layer.borderWidth = 3
//        containerBottom.layer.borderColor = UIColor.red.cgColor
        self.containerBottom.layer.cornerRadius  = 20
        self.constraintContainerBottomHeight.constant = CGFloat(50*(self.screen2MenuArray.count+3))
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.constraintContainerBottomPoint.constant = 50
            self.tapOfChangeCategoryOpenPopUp = UITapGestureRecognizer()
            self.tapOfChangeCategoryOpenPopUp!.addTarget(self, action: #selector(self.handlerToHideContainer(tap:)))
            self.view.addGestureRecognizer(self.tapOfChangeCategoryOpenPopUp!)
            self.blurView.isHidden = false
            self.view.layoutIfNeeded()
        }, completion: {isCompleted in })
        
    }
    
    //MARK: - закрытие окна changeCategory
    @objc func changeCategoryClosePopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.constraintContainerBottomPoint.constant = -515
            self.blurView.isHidden = true
            self.view.removeGestureRecognizer(self.tapOfChangeCategoryOpenPopUp!)
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
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen2TableViewCellHeader
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote") as! Screen2TableViewCellNote
            cell.deligateScreen2 = self
            cell.setTag(tag: indexPath.row)
            cell.startCell()
            cell.textViewNotes.delegate = cell
            
            self.delegateScreen2TableViewCellNote = cell
//            self.tapOutsideTextViewToGoFromTextView = UITapGestureRecognizer()
//            self.tapOutsideTextViewToGoFromTextView!.addTarget(self, action: #selector(self.handlerOutsideTextViewToGoFrom(tap:)))
//            cell.textViewNotes.addGestureRecognizer(self.tapOutsideTextViewToGoFromTextView!)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategoryOrDate") as! Screen2TableViewCellCategoryOrDate
            cell.deligateScreen2 = self
            cell.setTag(tag: indexPath.row)
            cell.startCell()
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        if indexPath.row == 3 {
//            return 88
//        }
//        else{
//            return 44
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
