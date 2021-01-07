//
//  ViewController.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 07.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttonDaily: UIView!
    @IBOutlet var buttonWeekly: UIView!
    @IBOutlet var buttonMonthly: UIView!
    @IBOutlet var buttonYearly: UIView!
    
    @IBOutlet var bottomPopInList: UIView!
    
    
    @IBAction func buttonDailyGesture(_ sender: Any) {
        borderForMenuBotton(buttonDaily)
    }
    @IBAction func buttonWeeklyGesture(_ sender: Any) {
        borderForMenuBotton(buttonWeekly)
    }
    @IBAction func buttonMonthlyGesture(_ sender: Any) {
        borderForMenuBotton(buttonMonthly)
    }
    @IBAction func buttonYearlyGesture(_ sender: Any) {
        borderForMenuBotton(buttonYearly)
    }
    
    func borderForMenuBotton(_ specifyButton: UIView) {
        
        func borderRemove(_ specifyButton2: UIView){
            for view in specifyButton2.subviews{
                if view.tag == 1 {
                    view.removeFromSuperview()
                }
            }
        }
        
        func borderCreate(_ specifyButton3: UIView){
            let bottomBorderYes = UIView(frame: CGRect(x: 0, y: specifyButton.frame.size.height - 3, width: specifyButton.frame.size.width, height: 3))
            bottomBorderYes.backgroundColor = UIColor.red
            bottomBorderYes.tag = 1
            specifyButton3.addSubview(bottomBorderYes)
        }

        
        switch specifyButton {
        case buttonDaily:
            borderCreate(buttonDaily)
            borderRemove(buttonWeekly)
            borderRemove(buttonMonthly)
            borderRemove(buttonYearly)
        case buttonWeekly:
            borderRemove(buttonDaily)
            borderCreate(buttonWeekly)
            borderRemove(buttonMonthly)
            borderRemove(buttonYearly)
        case buttonMonthly:
            borderRemove(buttonDaily)
            borderRemove(buttonWeekly)
            borderCreate(buttonMonthly)
            borderRemove(buttonYearly)
        case buttonYearly:
            borderRemove(buttonDaily)
            borderRemove(buttonWeekly)
            borderRemove(buttonMonthly)
            borderCreate(buttonYearly)
        default:
            print("Error with borderForMenuBotton")
        }
}

    
//    -------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.buttonMonthly.addSubview

//        screenMain.backgroundColor = UIColor(cgColor: CGColor.init(srgbRed: 0.4, green: 0.74, blue: 0.75, alpha: 1))
//        @IBDesignable @IBInspectable bottomPopInList
        

        
        // Do any additional setup after loading the view.
    }


}

