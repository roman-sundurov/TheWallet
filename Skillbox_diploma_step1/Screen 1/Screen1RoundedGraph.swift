//
//  Screen1RoundedGraph.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 02.06.2021.
//

import UIKit

protocol protocolScreen1RoundedGraph {
    func setDelegateScreen1RoundedGraph(delegate: protocolScreen1Delegate)
}

@IBDesignable class Screen1RoundedGraph: UIView {
    
    private enum Constants{
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
    }
    
    
    //MARK: - делегаты и переменные
    
    var deligateScreen1: protocolScreen1Delegate?
    
    var incomesColor: UIColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    var expensesColor: UIColor = UIColor.red
    
    
    //MARK: - draw()
    
    override func draw(_ rect: CGRect) {
        
        var localData = deligateScreen1?.returnDataArrayOfOperations()
        
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = max(bounds.width, bounds.height)
        
        let startAngle: CGFloat = .pi / 2
        
        let path = UIBezierPath(arcCenter: center, radius: radius/2-Constants.arcWidth/2, startAngle: startAngle, endAngle: .pi * 3 / 2, clockwise: true)
        
        path.lineWidth = Constants.lineWidth
        incomesColor.setStroke()
        path.stroke()
    }
    
    
    //Draw the outline
    
}

 
extension Screen1RoundedGraph: protocolScreen1RoundedGraph{
    
    func setDelegateScreen1RoundedGraph(delegate: protocolScreen1Delegate) {
        deligateScreen1 = delegate
    }
    
    
}
