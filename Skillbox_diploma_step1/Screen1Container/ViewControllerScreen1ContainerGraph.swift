//
//  ViewScreen1ContainerGraph.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 01.05.2021.
//

import UIKit

protocol protocolScreen1ContainerGraph{
    func startCell()
}

class ViewControllerScreen1ContainerGraph: UIViewController {
    
    var delegateScreen1: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()


    }

}


extension ViewControllerScreen1ContainerGraph: protocolScreen1ContainerGraph{
    func startCell() {
        return
    }
    
}
