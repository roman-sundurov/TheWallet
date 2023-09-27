//
//  VCMain.swift
//  MoneyManager
//
//  Created by Roman on 07.01.2021.
//

import UIKit
import JGProgressHUD
import GoogleMobileAds

protocol ProtocolVCMain {
    func updateScreen() // full screen update
    func showOperation(_ id: UUID) throws // opens a PopUp window for a specific operation
    func hideOperation() throws // closes the PopUp window of a specific operation
    func editOperation(uuid: UUID) // transition to editing the selected operation on the second screen
    func returnMonthOfDate(_ dateInternal: Date) -> String
    func returnGraphData() -> [GraphData]
    func showAlert(message: String)
    func clearTagForEdit()
}

class VCMain: UIViewController {
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
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: - delegates and variables
    var tapShowOperation: UITapGestureRecognizer?
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

        if let viewController = segue.destination as? VCSetting,
           segue.identifier == SegueIdentifiers.segueToVCSettingForEdit.rawValue {
            do {
                let userRepositoryUser = try dataManager.getUserData()
                viewController.vcMainDelegate = self
                if let specialOperation = userRepositoryUser.operations.filter({$0.value.id == tagForEdit}).first?.value {
                    dataManager.operationForEditing = specialOperation
                } else {
                    showAlert(message: "Error specialOperation")
                }
            } catch {
                showAlert(message: "Error VCSetting destination: userRepository.user")
            }
        }

        if let viewController = segue.destination as? VCOperation,
           segue.identifier == SegueIdentifiers.segueToVCOperation.rawValue {
            vcOperationDelegate = viewController
            viewController.vcMainDelegate = self
        }
    }

    // MARK: - clicks

    @IBAction func accountPage(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.segueToVCAccount.rawValue, sender: nil)
    }

    @IBAction func buttonDailyGesture(_ sender: Any) {
        do {
            try dataManager.getUserRepository().updateDaysForSorting(daysForSorting: 1)
            print("updateDaysForSorting 1= \(String(describing: dataManager.getUserRepository().user?.daysForSorting))")
            updateScreen()
        } catch {
            showAlert(message: "Database connection error, missing userReference")
        }
    }

    @IBAction func buttonWeeklyGesture(_ sender: Any) {
        do {
            try dataManager.getUserRepository().updateDaysForSorting(daysForSorting: 7)
            print("updateDaysForSorting 7= \(String(describing: dataManager.getUserRepository().user?.daysForSorting))")
            updateScreen()
        } catch {
            showAlert(message: "Database connection error, missing userReference")
        }
    }

    @IBAction func buttonMonthlyGesture(_ sender: Any) {
        do {
            try dataManager.getUserRepository().updateDaysForSorting(daysForSorting: 30)
            print("updateDaysForSorting 30= \(String(describing: dataManager.getUserRepository().user?.daysForSorting))")
            updateScreen()
        } catch {
            showAlert(message: "Database connection error, missing userReference")
        }
    }

    @IBAction func buttonYearlyGesture(_ sender: Any) {
        do {
            try dataManager.getUserRepository().updateDaysForSorting(daysForSorting: 365)
            print("updateDaysForSorting 365= \(String(describing: dataManager.getUserRepository().user?.daysForSorting))")
            updateScreen()
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

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        Task {
            hudAppear()
            do {
                try await dataManager.fetchFirebase {
                    do {
                        try self.applySnapshot()
                    } catch {
                        self.showAlert(message: "Error: applySnapshot")
                    }
                    self.updateScreen()
                    self.hudDisapper()
                }
            } catch {
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
            self.blurView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.blurView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.blurView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.blurView.isHidden = true

        // In this case, we instantiate the banner with desired ad size.
//        bannerView = GADBannerView(adSize: GADAdSizeBanner)

//           addBannerViewToView(bannerView)

        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // Real: ca-app-pub-1631070042993136/9057834651
        bannerView.rootViewController = self

        bannerView.delegate = self
        loadBannerAd()

        self.view.layoutIfNeeded()
    }

//    override func viewWillTransition(
//      to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
//    ) {
//      coordinator.animate(alongsideTransition: { _ in
//        if GoogleMobileAdsConsentManager.shared.canRequestAds {
//          self.loadBannerAd()
//        }
//      })
//    }
    
//    func addBannerViewToView(_ bannerView: GADBannerView) {
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        view.addConstraints(
//          [NSLayoutConstraint(item: bannerView,
//                              attribute: .bottom,
//                              relatedBy: .equal,
//                              toItem: view.safeAreaLayoutGuide,
//                              attribute: .bottom,
//                              multiplier: 1,
//                              constant: 0),
//           NSLayoutConstraint(item: bannerView,
//                              attribute: .centerX,
//                              relatedBy: .equal,
//                              toItem: view,
//                              attribute: .centerX,
//                              multiplier: 1,
//                              constant: 0)
//          ])
//       }

    func loadBannerAd() {
        // Here safe area is taken into account, hence the view frame is used after the
        // view has been laid out.
        let frame = { () -> CGRect in
            return view.frame.inset(by: view.safeAreaInsets)
        }()
        let viewWidth = frame.size.width

        // Here the current interface orientation is used. If the ad is being preloaded
        // for a future orientation change or different orientation, the function for the
        // relevant orientation should be used.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.backgroundColor = UIColor.green// UIColor(named: "DownMenuColor")

        bannerView.load(GADRequest())
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

extension VCMain: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
