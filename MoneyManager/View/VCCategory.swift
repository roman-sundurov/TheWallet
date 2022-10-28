//
//  ViewControllerScreen2Container.swift
//  MoneyManager
//
//  Created by Roman on 22.01.2021.
//

import UIKit

protocol protocolVCCategory {
  func closeWindow()
  func screen2ContainerNewCategorySwicher()
  func addNewCategory(name: String, icon: String, date: Double)
  func screen2ContainerDeleteCategory(idOfObject: UUID)
  func showAlertErrorAddNewCategory()
  func setCurrentActiveEditingCell(cellID: Int)
  func calculateCategoryArray() -> [Category]
  func returnScreen2StatusEditContainer() -> Bool
  func returnDelegateScreen2ContainerTableVCNewCategory() -> protocolCategoryTableVCNewCategory
  func returnVCMainDelegate() -> protocolVCMain
}

class VCCategory: UIViewController {
  // MARK: - outlets
  @IBOutlet var tableView: UITableView!

  // MARK: - delegates and variables
  var vcSettingDelegate: protocolVCSetting?
  var vcMainDelegate: protocolVCMain?
  var categoryTableVCHeaderDelegate: protocolCategoryTableVCHeader?
  var categoryTableVCNewCategoryDelegate: protocolCategoryTableVCNewCategory?
  var statusEditContainer = false
  var animationNewCategoryInCell = false
  var currentActiveCellID: Int?
  var categoriesArray: [Category] = []

  // MARK: - objects
  let alertErrorAddNewCategory = UIAlertController(
    title: "Введите название категории",
    message: nil,
    preferredStyle: .alert
    )

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    calculateCategoryArray()
    alertErrorAddNewCategory.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
  }
}
