//
//  ViewControllerScreen1Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 17.04.2021.
//

import UIKit

protocol protocolScreen1ContainerDelegate{
    
}

class ViewControllerScreen1Container: UIViewController{
    
    
    //MARK: - делегаты и переменные
    
    var delegateScreen1: protocolScreen1Delegate?

    
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

extension ViewControllerScreen1Container: protocolScreen1ContainerDelegate{
    
}
