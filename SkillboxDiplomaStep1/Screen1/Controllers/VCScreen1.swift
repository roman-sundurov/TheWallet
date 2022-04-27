//
//  ViewController.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 07.01.2021.
//


import UIKit
import RealmSwift

protocol protocolScreen1Delegate {
  func findAmountOfHeaders() // подсчёт заголовков с датами в основнй таблице экрана
  func screen1AllUpdate() // обновление данных на всэм экрана
  func actionsOperationsOpenPopUpScreen1(_ tag: Int) // открывает PopUp-окно конкретной операции
  func actionsOperationsClosePopUpScreen1() // закрывает PopUp-окно конкретной операции
  func editOperation(tag: Int) // переход в редактирование выбранной операции на втором экране
  func miniGraphStarterBackground(status: Bool)

  // // функции возврата
  func returnMonthOfDate(_ dateInternal: Date) -> String
  func returnDelegateScreen1GraphContainer() -> protocolScreen1ContainerGraph
  func returnIncomesExpenses() -> [String: Double]
  // interface update
  func tableViewReloadData()
}


class VCScreen1: UIViewController {
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
  @IBOutlet var containerBottomOperationScreen1: UIView!
  @IBOutlet var constraintContainerBottomPoint: NSLayoutConstraint!
  @IBOutlet var screen1MiniGraph: Screen1RoundedGraph!
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

  var tapOfActionsOperationsOpenPopUpScreen1: UITapGestureRecognizer?
  var delegateScreen2: protocolScreen2Delegate?
  private var delegateScreen1Container: protocolScreen1ContainerOperation?
  private var delegateScreen1GraphContainer: protocolScreen1ContainerGraph?

  // хранение модифицированных данных из Realm для конкретного режима отоборажения
  var tagForEdit: Int = 0
  var screen1StatusGrapjDisplay = false

  // MARK: - объекты
  let blurViewScreen1 = UIVisualEffectView(effect: UIBlurEffect(style: .dark))


  // MARK: - переходы
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vewController = segue.destination as? VCScreen2, segue.identifier == "segueToScreen2" {
      delegateScreen2 = vewController
      vewController.delegateScreen1 = self
    }
    if let viewController = segue.destination as? VCScreen1ContainerOperation, segue.identifier == "segueToScreen1Container" {
      delegateScreen1Container = viewController
      viewController.delegateScreen1 = self
    }
    if let viewController = segue.destination as? VCScreen1ContainerGraph,
       segue.identifier == "segueToScreen1GraphContainer" {
      delegateScreen1GraphContainer = viewController
      viewController.delegateScreen1 = self
    }
    if let viewController = segue.destination as? VCScreen2, segue.identifier == "segueToScreen2ForEdit"{
      viewController.screen2StatusEditing = true
      viewController.delegateScreen1 = self
      delegateScreen2 = viewController
      let dataArrayOfOperations = ViewModelScreen1.shared.returnDataArrayOfOperations()
      delegateScreen2?.setAmountInNewOperation(amount: dataArrayOfOperations[tagForEdit].amount)
      delegateScreen2?.setCategoryInNewOperation(category: dataArrayOfOperations[tagForEdit].category)
      delegateScreen2?.setDateInNewOperation(date: dataArrayOfOperations[tagForEdit].date)
      delegateScreen2?.setNoteInNewOperation(note: dataArrayOfOperations[tagForEdit].note)
      delegateScreen2?.setIDInNewOperation(id: dataArrayOfOperations[tagForEdit].id)
    }
  }

  // MARK: - клики
  @IBAction func buttonActionScreen1NewOperation(_ sender: Any) {
    performSegue(withIdentifier: "segueToScreen2", sender: nil)
  }

  @IBAction func buttonActionScreen1ShowGraph(_ sender: Any) {
    print("screen1StatusGrapjDisplay= \(screen1StatusGrapjDisplay)")
    if screen1StatusGrapjDisplay == false {
      // Блокировка показа данных за 1 день в режиме графика
      var daysForSorting = ViewModelScreen1.shared.returnDaysForSorting()
      if daysForSorting == 1 {
        ViewModelScreen1.shared.setDaysForSorting(newValue: 30)
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

  func changeDaysForSorting() {
    borderLineForMenu(days: ViewModelScreen1.shared.returnDaysForSorting())
    ViewModelScreen1.shared.screen1TableUpdateSorting()
    ViewModelScreen1.shared.daysForSortingRealmUpdate()
    countingIncomesAndExpensive()
    delegateScreen1GraphContainer?.containerGraphUpdate()
  }

  @IBAction func buttonDailyGesture(_ sender: Any) {
    ViewModelScreen1.shared.setDaysForSorting(newValue: 1)
    changeDaysForSorting()
  }

  @IBAction func buttonWeeklyGesture(_ sender: Any) {
    ViewModelScreen1.shared.setDaysForSorting(newValue: 7)
    changeDaysForSorting()
  }

  @IBAction func buttonMonthlyGesture(_ sender: Any) {
    ViewModelScreen1.shared.setDaysForSorting(newValue: 30)
    changeDaysForSorting()
  }

  @IBAction func buttonYearlyGesture(_ sender: Any) {
    ViewModelScreen1.shared.setDaysForSorting(newValue: 365)
    changeDaysForSorting()
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
      if containerBottomOperationScreen1.frame.contains(pointOfTap) {
        print("Tap inside Container")
      } else {
        print("Tap outside Container")
        actionsOperationsClosePopUpScreen1()
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
    let dataArrayOfOperations = ViewModelScreen1.shared.returnDataArrayOfOperations()
    income = 0
    expensive = 0
    for data in dataArrayOfOperations.filter({ $0.amount > 0 }) {
      income += data.amount
    }
    for data in dataArrayOfOperations.filter({ $0.amount < 0 }) {
      expensive += data.amount
    }

    if income.truncatingRemainder(dividingBy: 1) == 0 {
      labelAmountOfIncomes.text = "$\(String(format: "%.0f", income))"
    } else {
      labelAmountOfIncomes.text = "$\(String(format: "%.2f", income))"
    }
    if expensive.truncatingRemainder(dividingBy: 1) == 0 {
      labelAmountOfExpenses.text = "$\(String(format: "%.0f", expensive))"
    } else {
      labelAmountOfExpenses.text = "$\(String(format: "%.2f", expensive))"
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    borderLineForMenu(days: ViewModelScreen1.shared.returnDaysForSorting())
    ViewModelScreen1.shared.screen1TableUpdateSorting()
    self.view.layoutIfNeeded()
  }

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    screen1MiniGraph.setDelegateScreen1RoundedGraph(delegate: self)
    screen1AllUpdate()
    // округление углов на первом экране
    bottomPopInView.layer.cornerRadius = 20
    bottomPopInView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    bottomPopInView.clipsToBounds = true

    // Добавление Blur-эффекта
    self.view.insertSubview(self.blurViewScreen1, belowSubview: self.containerBottomOperationScreen1)
    self.blurViewScreen1.backgroundColor = .clear
    self.blurViewScreen1.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.blurViewScreen1.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.blurViewScreen1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.blurViewScreen1.heightAnchor.constraint(equalTo: self.view.heightAnchor),
      self.blurViewScreen1.widthAnchor.constraint(equalTo: self.view.widthAnchor)
    ])
    self.blurViewScreen1.isHidden = true

    self.view.layoutIfNeeded()
  }
}

// MARK: - additional protocols
extension VCScreen1: protocolScreen1Delegate {
  func miniGraphStarterBackground(status: Bool) {
    miniGraphStarterBackground.isHidden = status
  }

  func returnIncomesExpenses() -> [String: Double] {
    if income != 0 || expensive != 0 {
      print("income= \(income), expensive= \(expensive)")
      return ["income": income, "expensive": expensive]
    } else {
      return [:]
    }
  }

  func returnMonthOfDate(_ dateInternal: Date) -> String {
    let formatterPrint = DateFormatter()
    formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
    formatterPrint.dateFormat = "MMMM YYYY"
    return formatterPrint.string(from: dateInternal)
  }

  func returnDelegateScreen1GraphContainer() -> protocolScreen1ContainerGraph {
    return delegateScreen1GraphContainer!
  }

  func editOperation(tag: Int) {
    actionsOperationsClosePopUpScreen1()
    tagForEdit = tag
    performSegue(withIdentifier: "segueToScreen2ForEdit", sender: nil)
  }


  func screen1AllUpdate() {
    ViewModelScreen1.shared.screen1DataReceive()
    ViewModelScreen1.shared.screen1TableUpdateSorting()
    countingIncomesAndExpensive()
    changeDaysForSorting()
    screen1MiniGraph.setNeedsDisplay()
  }

  func findAmountOfHeaders() {
    return
  }

  // MARK: - PopUp-окно операции
  func actionsOperationsOpenPopUpScreen1(_ tag: Int) {
    containerBottomOperationScreen1.layer.cornerRadius = 20
    delegateScreen1Container?.startCell(tag: tag)

    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        self.constraintContainerBottomPoint.constant = 50
        self.tapOfActionsOperationsOpenPopUpScreen1 = UITapGestureRecognizer(
          target: self,
          action: #selector(self.handlerToHideContainerScreen1(tap:)))
        self.view.addGestureRecognizer(self.tapOfActionsOperationsOpenPopUpScreen1!)
        self.blurViewScreen1.isHidden = false
        self.view.layoutIfNeeded()
      },
      completion: { _ in })
  }


  func actionsOperationsClosePopUpScreen1() {
    UIView.animate(
      withDuration: 0,
      delay: 0,
      usingSpringWithDamping: 0,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        self.constraintContainerBottomPoint.constant = -311
        self.blurViewScreen1.isHidden = true
        self.view.removeGestureRecognizer(self.tapOfActionsOperationsOpenPopUpScreen1!)
        self.view.layoutIfNeeded()
      },
      completion: { _ in })
  }
}
