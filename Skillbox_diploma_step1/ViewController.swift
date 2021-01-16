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
    @IBOutlet var topMenuButtonStrip: UIView!
    @IBOutlet var labelDaily: UILabel!
    @IBOutlet var labelWeekly: UILabel!
    @IBOutlet var labelMothly: UILabel!
    @IBOutlet var labelYearly: UILabel!
    
    
    @IBOutlet var bottomPopInList: UIView!
    
    
    @IBAction func buttonDailyGesture(_ sender: Any) {
        topMenuHighliter(specifyLabel: labelDaily)
        borderForMenuBotton(buttonDaily)
    }
    @IBAction func buttonWeeklyGesture(_ sender: Any) {
        topMenuHighliter(specifyLabel: labelWeekly)
        borderForMenuBotton(buttonWeekly)
    }
    @IBAction func buttonMonthlyGesture(_ sender: Any) {
        topMenuHighliter(specifyLabel: labelMothly)
        borderForMenuBotton(buttonMonthly)
    }
    @IBAction func buttonYearlyGesture(_ sender: Any) {
        topMenuHighliter(specifyLabel: labelYearly)
        borderForMenuBotton(buttonYearly)
    }
    
    func topMenuHighliter(specifyLabel: UILabel){
        specifyLabel.font = UIFont.systemFont(ofSize: specifyLabel.font.pointSize, weight: .bold)
        switch specifyLabel {
        case labelDaily:
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("111")
        case labelWeekly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("222")
        case labelMothly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("333")
        case labelYearly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            print("444")
        default:
            print("Error with higlightLabel")
        }
    }
    
    func borderForMenuBotton(_ specifyButton: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
//            self.view.layoutIfNeeded()
            switch specifyButton {
            case self.buttonDaily:
                self.topMenuButtonStrip.frame.origin.x = self.buttonDaily.frame.origin.x + 10
            case self.buttonWeekly:
                self.topMenuButtonStrip.frame.origin.x = self.buttonWeekly.frame.origin.x + 10
            case self.buttonMonthly:
                self.topMenuButtonStrip.frame.origin.x = self.buttonMonthly.frame.origin.x + 10
            case self.buttonYearly:
                self.topMenuButtonStrip.frame.origin.x = self.buttonYearly.frame.origin.x + 10
            default:
                print("Error with borderForMenuBotton")
            }
        }, completion: {isCompleted in })
    }
    
    
//    -------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let redBox = UIView(frame: CGRect(x: 100, y: 100, width: 128, height: 128))
//        redBox.backgroundColor = .red
//        redBox.layer.cornerRadius = 25
//        redBox.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        bottomPopInList.addSubview(redBox)
        bottomPopInList.layer.cornerRadius  = 20
        bottomPopInList.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
//        self.buttonMonthly.addSubview

//        screenMain.backgroundColor = UIColor(cgColor: CGColor.init(srgbRed: 0.4, green: 0.74, blue: 0.75, alpha: 1))
//        @IBDesignable @IBInspectable bottomPopInList
        

        
        // Do any additional setup after loading the view.
    }


}
