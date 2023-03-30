//
//  vmMain.swift
//  MoneyManager
//
//  Created by Roman on 27.04.2022.
//

import Foundation
import UIKit

extension VCMain: ProtocolVCMain {

    func hudAppear() {
        hud.show(in: bottomPopInView)
        print("hudAppear")
    }

    func hudDisapper() {
        hud.dismiss(animated: true)
        print("hudDisapper")
    }

    // func miniGraphStarterBackground(status: Bool) {
    //     miniGraphStarterBackground.isHidden = status
    // }

    func returnMonthOfDate(_ dateInternal: Date) -> String {
        let formatterPrint = DateFormatter()
        formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
        formatterPrint.dateFormat = "MMMM YYYY"
        return formatterPrint.string(from: dateInternal)
    }

    func editOperation(uuid: UUID) {
        do {
            try hideOperation()
        } catch {
            showAlert(message: "hideOperation error")
        }
        tagForEdit = uuid
        performSegue(withIdentifier: PerformSegueIdentifiers.segueToVCSettingForEdit.rawValue, sender: nil)
    }

    func updateScreen() throws {
        do {
            let userData = try dataManager.getUserData()
            print("UpdateScreen daysForSorting= \(userData.daysForSorting)")
            borderLineForMenu(days: userData.daysForSorting)
            try dataManager.countingIncomesAndExpensive()

            miniGraph.setNeedsDisplay()
            configureDataSource()
            try applySnapshot()
        } catch {
            showAlert(message: "Error updateScreen")
        }
        confugureIncomeExpensiveLabels()
        if dataManager.income != 0 || dataManager.expensive != 0 {
            miniGraphStarterBackground.isHidden = true
        } else {
            miniGraphStarterBackground.isHidden = false
        }
    }

    // MARK: - PopUp-окно операции
    func showOperation(_ id: UUID) throws {
        if let tabBarController = tabBarController {
            tabBarController.tabBar.isUserInteractionEnabled = false
        } else {
            print("Error: UITabBarController 1")
        }

        viewOperation.layer.cornerRadius = 20
        vcOperationDelegate?.prepareForStart(id: id)
        self.tapShowOperation = UITapGestureRecognizer(
            target: self,
            action: #selector(self.handlerToHideContainerScreen1(tap:)))
        if let tapShowOperation = self.tapShowOperation {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                self.constraintContainerBottomPoint.constant = 80
                self.view.addGestureRecognizer(tapShowOperation)
                self.blurView.isHidden = false
                self.view.layoutIfNeeded()
            },
            completion: { _ in })
        } else {
            throw ThrowError.showOperation
        }
    }

    func hideOperation() throws {
        if let tapShowOperation = self.tapShowOperation {
            if let tabBarController = tabBarController {
                tabBarController.tabBar.isUserInteractionEnabled = true
            } else {
                print("Error: UITabBarController 1")
            }
        UIView.animate(
            withDuration: 0,
            delay: 0,
            usingSpringWithDamping: 0,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                self.constraintContainerBottomPoint.constant = -311
                self.blurView.isHidden = true
                self.view.removeGestureRecognizer(tapShowOperation)
                self.view.layoutIfNeeded()
            },
            completion: { _ in })
        } else {
            throw ThrowError.hideOperation
        }
    }

    func returnDayOfDate(_ dateInternal: Date) -> String {
        let formatterPrint = DateFormatter()
        formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
        do {
            switch try dataManager.getUserData().daysForSorting {
            case 365:
                formatterPrint.dateFormat = "MMMM YYYY"
            default:
                formatterPrint.dateFormat = "d MMMM YYYY"
            }
        } catch {
            formatterPrint.dateFormat = "d MMMM YYYY"
        }
        return formatterPrint.string(from: dateInternal)
    }

    func returnGraphData() -> [GraphData] {
        return graphDataArray
    }
}
