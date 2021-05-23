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
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var graphView: GraphView!
    @IBOutlet var weeklyStackView: UIStackView!
   
    
    //MARK: - делегаты и переменные
    
    var delegateScreen1: ViewController?

    
    //Mark: - Functions
    
    func countFullPointsArray(){
        for [a:b] in delegateScreen1?.returnGraphData() {
            print("n= \(n)")
        }
    }
    
    
    //MARK: - viewDidLoad
    
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
