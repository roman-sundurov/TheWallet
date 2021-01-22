//
//  ViewControllerScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 22.01.2021.
//

import UIKit

protocol protocol_deligate {
    func change_color(_ new_color: UIColor)
}

class ViewControllerScreen2Container: UIViewController {
    
    var deligateScreen2: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

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

extension ViewControllerScreen2Container: protocol_deligate {
    func change_color(_ new_color: UIColor) {
        self.view.backgroundColor = new_color
    }
}
