//
//  VCMain.swift
//  MoneyManager
//
//  Created by Roman on 07.01.2021.
//


import UIKit

protocol protocolVCMain {
  func updateScreen() // обновление данных на всэм экрана
  func showOperation(_ id: UUID) // открывает PopUp-окно конкретной операции
  func hideOperation() // закрывает PopUp-окно конкретной операции
  func editOperation(uuid: UUID) // переход в редактирование выбранной операции на втором экране
  func miniGraphStarterBackground(status: Bool)

  // // функции возврата
  func returnMonthOfDate(_ dateInternal: Date) -> String
  func returnDelegateScreen1GraphContainer() -> protocolVCGraph
  func returnIncomesExpenses() -> [String: Double]
  // // interface update
  // func tableViewReloadData()
  func returnArrayForIncrease() -> [Int]
  func getUserRepository() -> UserRepository
  func getUserData() -> User
  func updateUserData(newData: User)
  
  func updateOperations(amount: Double, categoryUUID: UUID, note: String, date: Date, idOfObject: UUID)
  func addOperations(amount: Double, categoryUUID: UUID, note: String, date: Date)
  func deleteCategory(idOfObject: UUID)
  func updateCategory(name: String, icon: String, idOfObject: UUID)
  func returnGraphData() -> [GraphData]
  func addCategory(name: String, icon: String, date: Double)
  func deleteOperation(uuid: UUID)
  func fetchFirebase()
}


class VCMain: UIViewController {
  static let shared = VCMain()

    // MARK: - объявление аутлетов
  @IBOutlet var tableViewScreen1: UITableView!
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
  @IBOutlet var miniGraph: MainViewRoundedGraph!
  @IBOutlet var screen1BottomMenu: UIView!
  @IBOutlet var scrollViewFromBottomPopInView: UIScrollView!
  @IBOutlet var graphFromBottomPopInView: UIView!
  @IBOutlet var buttonScreen1NewOperation: UIButton!
  @IBOutlet var buttonScreen1ShowGraph: UIButton!
  @IBOutlet var buttonScreen1ShowList: UIButton!
  @IBOutlet var miniGraphStarterBackground: UIView!

    // MARK: - делегаты и переменные
  var income: Double = 0
  var expensive: Double = 0

  var tapShowOperation: UITapGestureRecognizer?
  var vcSettingDelegate: protocolVCSetting?
  var vcOperationDelegate: protocolVCOperation?
  var vcGraphDelegate: protocolVCGraph?

    // хранение модифицированных данных из Realm для конкретного режима отоборажения
  var tagForEdit: UUID?
  var screen1StatusGrapjDisplay = false

    // показывает количество заголовков с новой датой в таблице, которое предшествует конкретной операции
  var arrayForIncrease: [Int] = [0]
  var graphDataArray: [GraphData] = []

  var datasource: MyDataSource?
  var userRepository = UserRepository.shared
  // var userData: User? {
  //   get {
  //     return userRepository.user
  //   }
  //   set(userData) {
  //     userRepository.user = userData
  //   }
  // }

  let dateFormatter = DateFormatter()


  // MARK: - объекты
  let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))


  // MARK: - переходы
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vewController = segue.destination as? VCSetting, segue.identifier == "segueToVCSetting" {
      vcSettingDelegate = vewController
      vewController.vcMainDelegate = self
    }

    if let viewController = segue.destination as? VCOperation, segue.identifier == "segueToVCOperation" {
      vcOperationDelegate = viewController
      viewController.vcMainDelegate = self
    }

    // if let viewController = segue.destination as? VCGraph,
    //    segue.identifier == "segueToScreen1GraphContainer" {
    //   vcGraphDelegate = viewController
    //   viewController.vcMainDelegate = self
    // }

    if let viewController = segue.destination as? VCSetting, segue.identifier == "segueToVCSettingForEdit"{
      viewController.vcSettingStatusEditing = true
      viewController.vcMainDelegate = self
      vcSettingDelegate = viewController
      let specialOperation = userRepository.user!.operations.filter({$0.value.id == tagForEdit}).first?.value
      vcSettingDelegate!.setVCSetting(amount: specialOperation!.amount, categoryUUID: specialOperation!.category!, date: specialOperation!.date, note: specialOperation!.note, id: specialOperation!.id)
    }
  }

  // MARK: - клики
  @IBAction func buttonActionScreen1NewOperation(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCSetting", sender: nil)
  }

  @IBAction func search(_ sender: Any) {
    // Task {
    //   do {
    //     try? await userRepository.getUserData() { data in
    //       self.userData = data
    //       print("userData= \(self.userData)")
    //     }
    //   } catch {
    //     print("userRepositoryInstance Error")
    //   }
    // }

  }

  @IBAction func buttonActionScreen1ShowGraph(_ sender: Any) {
    print("screen1StatusGrapjDisplay= \(screen1StatusGrapjDisplay)")
    if screen1StatusGrapjDisplay == false {
      // Блокировка показа данных за 1 день в режиме графика
      var daysForSorting = userRepository.user!.daysForSorting
      if daysForSorting == 1 {
        setDaysForSorting(newValue: 30)
        daysForSorting = 30
        buttonWeeklyGesture(self)
      }
      buttonDaily.isUserInteractionEnabled = false
      buttonDaily.alpha = 0.3

      UIView.transition(
      from: scrollViewFromBottomPopInView,
      to: graphFromBottomPopInView,
      duration: 1.0,
      options: [.transitionFlipFromLeft, .showHideTransitionViews],
      completion: nil
    )
      screen1StatusGrapjDisplay = true
      buttonScreen1ShowGraph.setImage(UIImage.init(named: "Left-On"), for: .normal)
      buttonScreen1ShowList.setImage(UIImage.init(named: "Right-Off"), for: .normal)
    }
  }

  @IBAction func buttonActionScreen1ShowList(_ sender: Any) {
    if screen1StatusGrapjDisplay == true {
      UIView.transition(
      from: graphFromBottomPopInView,
      to: scrollViewFromBottomPopInView,
      duration: 1.0,
      options: [.transitionFlipFromRight, .showHideTransitionViews],
      completion: nil
      )
      screen1StatusGrapjDisplay = false
      buttonScreen1ShowGraph.setImage(UIImage.init(named: "Left-Off"), for: .normal)
      buttonScreen1ShowList.setImage(UIImage.init(named: "Right-On"), for: .normal)
      buttonDaily.isUserInteractionEnabled = true
      buttonDaily.alpha = 1
    }
  }

  func changeDaysForSorting(newValue: Int) {
    borderLineForMenu(days: newValue)
    screen1TableUpdateSorting()
    tableViewScreen1.reloadData()
    userRepository.updateDaysForSorting(daysForSorting: newValue)
    countingIncomesAndExpensive()
    vcGraphDelegate?.containerGraphUpdate()
  }

  @IBAction func buttonDailyGesture(_ sender: Any) {
    setDaysForSorting(newValue: 1)
    changeDaysForSorting(newValue: 1)
  }

  @IBAction func buttonWeeklyGesture(_ sender: Any) {
    setDaysForSorting(newValue: 7)
    changeDaysForSorting(newValue: 7)
  }

  @IBAction func buttonMonthlyGesture(_ sender: Any) {
    setDaysForSorting(newValue: 30)
    changeDaysForSorting(newValue: 30)
  }

  @IBAction func buttonYearlyGesture(_ sender: Any) {
    setDaysForSorting(newValue: 365)
    changeDaysForSorting(newValue: 365)
  }

  @objc func switchScreen1GraphContainer(tap: UITapGestureRecognizer) {
    if tap.state == UIGestureRecognizer.State.ended {
      print("Tap Graph ended")
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
        hideOperation()
      }
    }
  }

  // MARK: - верхнее меню
  func topMenuHighliter(specifyLabel: UILabel) {
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

  func countingIncomesAndExpensive() {
    // if let dataArrayOfOperations = userData?.operations {
    //   income = 0
    //   expensive = 0
    //   for data in dataArrayOfOperations.filter({ $0.value.amount > 0 }) {
    //     income += data.value.amount
    //   }
    //   for data in dataArrayOfOperations.filter({ $0.value.amount < 0 }) {
    //     expensive += data.value.amount
    //   }
    //
    //   if income.truncatingRemainder(dividingBy: 1) == 0 {
    //     labelAmountOfIncomes.text = "$\(String(format: "%.0f", income))"
    //   } else {
    //     labelAmountOfIncomes.text = "$\(String(format: "%.2f", income))"
    //   }
    //   if expensive.truncatingRemainder(dividingBy: 1) == 0 {
    //     labelAmountOfExpenses.text = "$\(String(format: "%.0f", expensive))"
    //   } else {
    //     labelAmountOfExpenses.text = "$\(String(format: "%.2f", expensive))"
    //   }
    // }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // borderLineForMenu(days: userRepository.user!.daysForSorting)
    screen1TableUpdateSorting()
    tableViewScreen1.reloadData()
    self.view.layoutIfNeeded()
  }

  override func viewWillAppear(_ animated: Bool) {
    Task {
      do {
        // userRepository.semaphore = DispatchSemaphore(value: 0)
        try? await userRepository.getUserData() { data in
          self.userRepository.user = data
          print("userData= \(self.userRepository.user)")
          // self.userRepository.semaphore.signal()
        }
        // userRepository.semaphore.wait()
        print("userData 111")
      } catch {
        print("userRepositoryInstance Error")
      }
    }

  }

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad")

    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    configureDataSource()
    applySnapshot()

    Task {
      do {
        try? await userRepository.getUserData() { data in
          self.userRepository.user = data
          print("NewData= \(self.userRepository.user)")
          self.applySnapshot()
        }
        print("NewData2= \(userRepository.user)")
      } catch {
        print("Error22")
      }
    }


    miniGraph.setDelegateScreen1RoundedGraph(delegate: self)
    // updateScreen()
    // округление углов на первом экране
    bottomPopInView.layer.cornerRadius = 20
    bottomPopInView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    bottomPopInView.clipsToBounds = true

    // Добавление Blur-эффекта
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

    // self.view.layoutIfNeeded()
  }
}
