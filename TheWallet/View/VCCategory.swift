//
//  ViewControllerScreen2Container.swift
//  MoneyManager
//
//  Created by Roman on 22.01.2021.
//

import UIKit

protocol ProtocolVCCategory {
    func closeWindow()
    func screen2ContainerNewCategorySwicher()
    func addNewCategory(name: String, icon: String, date: Double)
    func screen2ContainerDeleteCategory(idOfObject: UUID)
    func showAlertErrorAddNewCategory()
    func setCurrentActiveEditingCell(cellID: Int)
    func calculateCategoryArray() -> [Category]
    func returnScreen2StatusEditContainer() -> Bool
    func returnDelegateScreen2ContainerTableVCNewCategory() throws -> ProtocolCategoryTableVCNewCategory
    func returnVCMainDelegate() throws -> ProtocolVCMain
}

class VCCategory: UIViewController {
    // MARK: - outlets
    @IBOutlet var tableView: UITableView!

    // MARK: - delegates and variables
    var vcSettingDelegate: ProtocolVCSetting?
    var vcMainDelegate: ProtocolVCMain?
    var categoryTableVCHeaderDelegate: ProtocolCategoryTableVCHeader?
    var categoryTableVCNewCategoryDelegate: ProtocolCategoryTableVCNewCategory?
    var statusEditContainer = false
    var animationNewCategoryInCell = false
    var currentActiveCellID: Int?
    var categoriesArray: [Category] = []

    // MARK: - objects
    let alertErrorAddNewCategory = UIAlertController(
        title: "Enter category name",
        message: nil,
        preferredStyle: .alert
    )

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = calculateCategoryArray()
        alertErrorAddNewCategory.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }
}
