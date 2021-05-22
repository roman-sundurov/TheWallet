//
//  GraphView.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 16.05.2021.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    // Weekly sample data
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]
    
    
    override func draw(_ rect: CGRect) {
         
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: 8, height: 8)
        )
        path.addClip()
        
    }

}
