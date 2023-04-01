//
//  VCMain.swift
//  MoneyManager
//
//  Created by Roman on 07.01.2021.
//

import UIKit
import JGProgressHUD

protocol ProtocolVCMain {
    func updateScreen() throws // full screen update
    func showOperation(_ id: UUID) throws // opens a PopUp window for a specific operation
    func hideOperation() throws // closes the PopUp window of a specific operation
    func editOperation(uuid: UUID) // transition to editing the selected operation on the second screen
    // func miniGraphStarterBackground(status: Bool)
    func returnMonthOfDate(_ dateInternal: Date) -> String
    func returnGraphData() -> [GraphData]
    func showAlert(message: String)
}

// swiftlint:disable all
class VCMain: UIViewController {
    // swiftlint:enable all
    static let shared = VCMain()

    // MARK: - outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonDaily: UIView!
    @IBOutlet var buttonWeekly: UIView!
    @IBOutlet var buttonMonthly: UIView!
    @IBOutlet var buttonYearly: UIView!
    @IBOutlet var topMenuButtonStrip: UIView!
    @IBOutlet var labelDaily: UILabel!
    @IBOutlet var labelWeekly: UILabel!
    @IBOutlet var labelMothly: UILabel!
    @IBOutlet var labelYearly: UILabel!
    @IBOutlet var bottomPopInView: UIView!
    @IBOutlet var labelAmountOfIncomes: UILabel!
    @IBOutlet var labelAmountOfExpenses: UILabel!
    @IBOutlet var constraintTopMenuBottomStrip: NSLayoutConstraint!
    @IBOutlet var viewOperation: UIView!
    @IBOutlet var constraintContainerBottomPoint: NSLayoutConstraint!
    @IBOutlet var miniGraph: RoundedGraphView!
    @IBOutlet var scrollViewFromBottomPopInView: UIScrollView!
    @IBOutlet var miniGraphStarterBackground: UIView!
    @IBOutlet var graphNoTransactionView: UIView!

    // MARK: - delegates and variables

    var tapShowOperation: UITapGestureRecognizer?
    var vcSettingDelegate: ProtocolVCSetting?
    var vcOperationDelegate: ProtocolVCOperation?
    var tagForEdit: UUID?
    var screen1StatusGrapjDisplay = false
    var arrayForIncrease: [Int] = [0]
    var graphDataArray: [GraphData] = []
    var datasource: MyDataSource?

    let dateFormatter = DateFormatter()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let hud = JGProgressHUD()

    // MARK: - transitions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vewController = segue.destination as? VCSetting,
           segue.identifier == PerformSegueIdentifiers.segueToVCSetting.rawValue {
            vcSettingDelegate = vewController
            vewController.vcMainDelegate = self
        }
        if let viewController = segue.destination as? VCOperation,
           segue.identifier == PerformSegueIdentifiers.segueToVCOperation.rawValue {
            vcOperationDelegate = viewController
            viewController.vcMainDelegate = self
        }
        // if let viewController = segue.destination as? VCGraph,
        //    segue.identifier == PerformSegueIdentifiers.segueToVCGraph.rawValue {
        //     vcGraphDelegate = viewController
        //     viewController.vcMainDelegate = self
        // }
        if let viewController = segue.destination as? VCSetting,
           segue.identifier == PerformSegueIdentifiers.segueToVCSettingForEdit.rawValue {
            do {
                let userRepositoryUser = try dataManager.getUserData()
                viewController.vcSettingStatusEditing = true
                viewController.vcMainDelegate = self
                vcSettingDelegate = viewController
                if let specialOperation = userRepositoryUser.operations.filter({$0.value.id == tagForEdit}).first?.value {
                    if let vcSettingDelegate = vcSettingDelegate {
                        if let specialOperationCategory = specialOperation.category {
                            vcSettingDelegate.setVCSetting(
                                amount: specialOperation.amount,
                                categoryUUID: specialOperationCategory,
                                date: specialOperation.date,
                                note: specialOperation.note,
                                id: specialOperation.id
                            )
                        } else {
                            showAlert(message: "Error specialOperationCategory")
                        }
                    } else {
                        showAlert(message: "Error vcSettingDelegate == nil")
                    }
                } else {
                    showAlert(message: "Error specialOperation")
                }
            } catch {
                showAlert(message: "Error VCSetting destination: userRepository.user")
            }
        }
    }

    // MARK: - clicks

    @IBAction func accountPage(_ sender: Any) {
        performSegue(withIdentifier: PerformSegueIdentifiers.segueToVCAccount.rawValue, sender: nil)
    }

    @IBAction func buttonDailyGesture(_ sender: Any) {
        do {
            try dataManager.getUserRepository().updateDaysForSorting(daysForSorting: 1)
            print("updateDaysForSorting 1= \(dataManager.getUserRepository().user?.daysForSorting)")
            try updateScreen()
        } catch ThrowError.mainViewUpdateScreen {
            showAlert(message: "Screen update error")
        } catch {
            showAlert(message: "Database connection error, missing userReference")
        }
    }

    @IBAction func buttonWeeklyGesture(_ sender: Any) {
        do {
            try dataManager.getUserRepository().updateDaysForSorting(daysForSorting: 7)
            print("updateDaysForSorting 7= \(dataManager.getUserRepository().user?.daysForSorting)")
            try updateScreen()
        } catch ThrowError.mainViewUpdateScreen {
            showAlert(message: "Screen update error")
        } catch {
            showAlert(message: "Database connection error, missing userReference")
        }
    }

    @IBAction func buttonMonthlyGesture(_ sender: Any) {
        do {
            try dataManager.getUserRepository().updateDaysForSorting(daysForSorting: 30)
            print("updateDaysForSorting 30= \(dataManager.getUserRepository().user?.daysForSorting)")
            try updateScreen()
        } catch ThrowError.mainViewUpdateScreen {
            showAlert(message: "Screen update error")
        } catch {
            showAlert(message: "Database connection error, missing userReference")
        }
    }

    @IBAction func buttonYearlyGesture(_ sender: Any) {
        do {
            try dataManager.getUserRepository().updateDaysForSorting(daysForSorting: 365)
            print("updateDaysForSorting 365= \(dataManager.getUserRepository().user?.daysForSorting)")
            try updateScreen()
        } catch ThrowError.mainViewUpdateScreen {
            showAlert(message: "Screen update error")
        } catch {
            showAlert(message: "Database connection error, missing userReference")
        }
    }

    @objc func handlerToHideContainerScreen1(tap: UITapGestureRecognizer) {
        if tap.state == UIGestureRecognizer.State.ended {
            print("Tap ended")
            let pointOfTap = tap.location(in: self.view)
            if viewOperation.frame.contains(pointOfTap) {
                print("Tap inside Container")
            } else {
                print("Tap outside Container")
                do {
                    try hideOperation()
                } catch {
                    showAlert(message: "hideOperation error")
                }
            }
        }
    }

    // MARK: - top Menu
    private func topMenuHighliter(specifyLabel: UILabel) {
        specifyLabel.font = UIFont.systemFont(ofSize: specifyLabel.font.pointSize, weight: .bold)
        switch specifyLabel {
        case labelDaily:
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("111")
        case labelWeekly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("222")
        case labelMothly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelYearly.font = UIFont.systemFont(ofSize: labelYearly.font.pointSize, weight: .medium)
            print("333")
        case labelYearly:
            labelDaily.font = UIFont.systemFont(ofSize: labelDaily.font.pointSize, weight: .medium)
            labelWeekly.font = UIFont.systemFont(ofSize: labelWeekly.font.pointSize, weight: .medium)
            labelMothly.font = UIFont.systemFont(ofSize: labelMothly.font.pointSize, weight: .medium)
            print("444")
        default:
            print("Error with higlightLabel")
        }
    }

    func borderLineForMenu(days: Int) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                switch days {
                case 1:
                    self.constraintTopMenuBottomStrip.constant = self.buttonDaily.frame.origin.x + 10
                    self.topMenuHighliter(specifyLabel: self.labelDaily)
                    print("borderForMenuBottom 1")
                case 7:
                    self.constraintTopMenuBottomStrip.constant = self.buttonWeekly.frame.origin.x + 10
                    print("borderForMenuBottom 7")
                    self.topMenuHighliter(specifyLabel: self.labelWeekly)
                case 30:
                    self.constraintTopMenuBottomStrip.constant = self.buttonMonthly.frame.origin.x + 10
                    self.topMenuHighliter(specifyLabel: self.labelMothly)
                    print("borderForMenuBottom 30")
                case 365:
                    self.constraintTopMenuBottomStrip.constant = self.buttonYearly.frame.origin.x + 10
                    self.topMenuHighliter(specifyLabel: self.labelYearly)
                    print("borderForMenuBottom 365")
                default:
                    print("Error with borderForMenuBotton")
                }
            }, completion: { _ in })
    }

    func confugureIncomeExpensiveLabels() {
        if dataManager.income.truncatingRemainder(dividingBy: 1) == 0 {
            labelAmountOfIncomes.text = "$\(String(format: "%.0f", dataManager.income))"
        } else {
            labelAmountOfIncomes.text = "$\(String(format: "%.2f", dataManager.income))"
        }
        
        if dataManager.expensive.truncatingRemainder(dividingBy: 1) == 0 {
            labelAmountOfExpenses.text = "$\(String(format: "%.0f", dataManager.expensive))"
        } else {
            labelAmountOfExpenses.text = "$\(String(format: "%.2f", dataManager.expensive))"
        }
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        Task {
            hudAppear()
            do {
                try await dataManager.fetchFirebase() {
                    do {
                        try self.applySnapshot()
                    } catch {
                        self.showAlert(message: "Error: applySnapshot")
                    }
                    do {
                        try self.updateScreen()
                    } catch {
                        self.showAlert(message: "Screen update error")
                    }
                    self.hudDisapper()
                }
            } catch ThrowError.getUserDataError {
                hudDisapper()
                showAlert(message: "Database connection error, missing userReference")
            }
        }

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        configureDataSource()

        bottomPopInView.layer.cornerRadius = 20
        bottomPopInView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomPopInView.clipsToBounds = true

        // adding a blur effect
        self.view.insertSubview(self.blurView, belowSubview: self.viewOperation)
        self.blurView.backgroundColor = .clear
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.blurView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.blurView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            self.blurView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        self.blurView.isHidden = true
    }

    func showAlert(message: String) {
        let alert = UIAlertController(
          title: message,
          message: nil,
          preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil)
    }
}
