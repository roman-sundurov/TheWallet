//
//  Screen1TableViewCellHeader.swift
//  MoneyManager
//
//  Created by Roman on 26.01.2021.
//

import UIKit

class MainViewCellHeader: UITableViewCell {
  @IBOutlet var labelHeaderDate: UILabel!

  var vcMainDelegate: protocolVCMain?
  // var specCellTag: Int = 0
  var doubleDate: Double = 0

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func startCellEmpty() {
    // print("HeaderEmpty: ---")
    // labelHeaderDate.text = "No entries yet."
  }


  func startCell() {
    // print("Header1: ---")
    // let formatterPrint = DateFormatter()
    // formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
    // formatterPrint.dateFormat = "d MMMM YYYY"
  }

  func startCell2() {
    // print("Header2: ---")
    // let formatterPrint = DateFormatter()
    // formatterPrint.dateFormat = "d MMMM YYYY"
    // // let specVar: Int = specCellTag - vcMainDelegate!.returnArrayForIncrease()[specCellTag - 1]
    // // print("222: \(formatterPrint.string(from: (vcMainDelegate!.getUserData().operations[specVar]!.date)))")
    // labelHeaderDate.text = formatterPrint.string(from: Date(timeIntervalSince1970: doubleDate))
  }

  // func setTag(tag: Int) {
  //   specCellTag = tag
  // }
}
