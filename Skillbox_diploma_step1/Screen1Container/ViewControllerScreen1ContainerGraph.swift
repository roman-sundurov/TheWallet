//
//  ViewScreen1ContainerGraph.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 01.05.2021.
//

import UIKit

protocol protocolScreen1ContainerGraph{
    func containerGraphUpdate()
}

class ViewControllerScreen1ContainerGraph: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var graphView: GraphView!
    @IBOutlet var weeklyStackView: UIStackView!
   
    
    //MARK: - делегаты и переменные
    
    var delegateScreen1: ViewController?

    
    //Mark: - Functions
    
    func countFullPointsArray(){
        print("countFullPointsArray")
        guard let graphData = delegateScreen1?.returnGraphData() else { return }
        print("graphData= \(graphData)")
        
        var graphData2: [GraphData]
        
        //Заполнение gthдней, в которых не было операций
        
        //Проверка наличия операция сегодня. Если нет проставляется значение ближайшей записи.
        if delegateScreen1?.returnDayOfDate(dateInternal: graphData[0].date) != delegateScreen1?.returnDayOfDate(dateInternal: Date()){
            graphData2.insert(GraphData(newDate: Date(), newAmount: graphData.first!.cumulativeAmount), at: 0)
        }
        
        //Проверка заполнения оставшихся дней. Если запись пуста - ставим предыдущую.
        for x in graphData {
            for n in 1..<(delegateScreen1?.returnDaysForSorting())!{
                
            }

        }


        for n in graphData2 {
            print("n= \(n.cumulativeAmount)")
        }
        
//        delegateScreen1.setGraphPo
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
    
    func containerGraphUpdate() {
        countFullPointsArray()
    }
    
    
}
