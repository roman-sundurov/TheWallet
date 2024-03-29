//
//  RoundedGraphView.swift
//  MoneyManager
//
//  Created by Roman on 02.06.2021.
//

import UIKit

// @IBDesignable
final class RoundedGraphView: UIView {
    private enum Constants {
        static let lineWidth: CGFloat = 25.0
        static let arcWidth: CGFloat = 76
    }

        // MARK: - delegates and variables
    var incomesColor = UIColor(cgColor: CGColor.init(srgbRed: 0.165, green: 0.671, blue: 0.014, alpha: 1))
    var expensesColor = UIColor.red

        // MARK: - draw()
    override func draw(_ rect: CGRect) {
        let data = [
            "income": dataManager.income,
            "expensive": dataManager.expensive
        ]
        var incomesExpensesRatio: Double = 1

        if data["income"] == 0 && data["expensive"] != 0 {
            incomesExpensesRatio = -1
        } else {
            incomesExpensesRatio = data.isEmpty ? 0 : data["income"]! / (data["income"]! - data["expensive"]!)
        }

        print("incomesExpensesRatio= \(incomesExpensesRatio)")

        if !data.isEmpty {
            let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            let radius = max(bounds.width, bounds.height)

            let startAngleIncome: CGFloat = .pi / 2
            let startAngleExpenses: CGFloat = .pi * 2 * CGFloat(incomesExpensesRatio) + startAngleIncome

            let pathIncome = UIBezierPath(
                arcCenter: center,
                radius: radius / 2 - Constants.arcWidth / 2,
                startAngle: startAngleIncome,
                endAngle: startAngleExpenses,
                clockwise: true)
            pathIncome.lineWidth = Constants.lineWidth
            incomesColor.setStroke()
            pathIncome.stroke()

            let pathExpenses = UIBezierPath(
                arcCenter: center,
                radius: radius / 2 - Constants.arcWidth / 2,
                startAngle: startAngleExpenses,
                endAngle: startAngleIncome,
                clockwise: true)
            pathExpenses.lineWidth = Constants.lineWidth
            expensesColor.setStroke()
            pathExpenses.stroke()
        }
    }

}
