//
//  MainTabBarController.swift
//  TheWallet
//
//  Created by Roman on 29.03.2023.
//

import UIKit

// protocol MainTabBarControllerProtocol {
//     func setVCMain(newValue: ProtocolVCMain)
// }

class MainTabBarController: UITabBarController {

    var vcMainDelegate: ProtocolVCMain?

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = 2

        // if let myChildViewController = self.tabBarController?.viewControllers?[0] as? VCMain {
        //     vcMainDelegate = myChildViewController
        // }
        // Do any additional setup after loading the view.

        // let childViewController = VCMain()
        // childViewController.tabBarController = self.tabBarController
        // self.addChild(childViewController)
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
