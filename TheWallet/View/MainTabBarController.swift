//
//  MainTabBarController.swift
//  TheWallet
//
//  Created by Roman on 29.03.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    var vcMainDelegate: ProtocolVCMain?

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = 2
    }

}
