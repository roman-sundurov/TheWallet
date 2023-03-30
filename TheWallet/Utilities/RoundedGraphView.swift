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

        if data.isEmpty {
            // vcMainDelegate?.miniGraphStarterBackground(status: false)
        } else {
            // vcMainDelegate?.miniGraphStarterBackground(status: true)
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

    // func countingIncomesAndExpensive() {
    //     if let operations = dataManager.getUserRepository().user?.operations,
    //     let userRepositoryUser = dataManager.getUserRepository().user {
    //         let freshHold = Date().timeIntervalSince1970 - Double(86400 * userRepositoryUser.daysForSorting)
    //
    //         income = 0
    //         expensive = 0
    //         for data in operations.filter({ $0.value.amount > 0 && $0.value.date > freshHold }) {
    //             income += data.value.amount
    //         }
    //         for data in operations.filter({ $0.value.amount < 0 && $0.value.date > freshHold }) {
    //             expensive += data.value.amount
    //         }
    //
    //         if income.truncatingRemainder(dividingBy: 1) == 0 {
    //             labelAmountOfIncomes.text = "$\(String(format: "%.0f", income))"
    //         } else {
    //             labelAmountOfIncomes.text = "$\(String(format: "%.2f", income))"
    //         }
    //
    //         if expensive.truncatingRemainder(dividingBy: 1) == 0 {
    //             labelAmountOfExpenses.text = "$\(String(format: "%.0f", expensive))"
    //         } else {
    //             labelAmountOfExpenses.text = "$\(String(format: "%.2f", expensive))"
    //         }
    //     } else {
    //         showAlert(message: "Error countingIncomesAndExpensive")
    //     }
    // }


    // func returnIncomesExpenses() -> [String: Double]? {
    //     if income != 0 || expensive != 0 {
    //         print("income= \(income), expensive= \(expensive)")
    //         return ["income": income, "expensive": expensive]
    //     } else {
    //         return nil
    //     }
    // }

}
