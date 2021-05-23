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
    
    @IBOutlet var graphView: GraphView!
    var delegateScreen1: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView.layer.cornerRadius = 20
        graphView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        graphView.clipsToBounds = true

    }

}


extension ViewControllerScreen1ContainerGraph: protocolScreen1ContainerGraph{
    func startCell() {
        return
    }
    
}
